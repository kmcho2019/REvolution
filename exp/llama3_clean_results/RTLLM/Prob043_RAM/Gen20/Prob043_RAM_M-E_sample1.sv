module RAM (
    input clk_write,
    input clk_read,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output [5:0] read_data
);

parameter WIDTH = 6;
parameter DEPTH = 8;

// Write Controller
reg [5:0] write_ram [7:0];
reg [2:0] write_addr_reg;
reg [5:0] write_data_reg;

always @(posedge clk_write or negedge rst_n) begin
    if (!rst_n) begin
        write_ram <= '{default: 6'b0};
        write_addr_reg <= 3'b0;
        write_data_reg <= 6'b0;
    end else if (write_en) begin
        write_ram[write_addr] <= write_data;
        write_addr_reg <= write_addr;
        write_data_reg <= write_data;
    end
end

// Asynchronous FIFO
reg [5:0] fifo [7:0];
reg [2:0] fifo_ptr;
reg fifo_empty;

always @(posedge clk_write or negedge rst_n) begin
    if (!rst_n) begin
        fifo <= '{default: 6'b0};
        fifo_ptr <= 3'b0;
        fifo_empty <= 1'b1;
    end else if (write_en) begin
        fifo[fifo_ptr] <= write_data;
        fifo_ptr <= fifo_ptr + 1;
        fifo_empty <= 1'b0;
    end
end

// Read Controller
reg [5:0] read_ram [7:0];
reg [2:0] read_addr_reg;
reg [5:0] read_data_reg;

always @(posedge clk_read or negedge rst_n) begin
    if (!rst_n) begin
        read_ram <= '{default: 6'b0};
        read_addr_reg <= 3'b0;
        read_data_reg <= 6'b0;
    end else if (read_en) begin
        read_data_reg <= read_ram[read_addr];
    end
end

// Clock Domain Crossing (CDC)
reg [5:0] cdc_data;
reg cdc_valid;

always @(posedge clk_read or negedge rst_n) begin
    if (!rst_n) begin
        cdc_data <= 6'b0;
        cdc_valid <= 1'b0;
    end else if (!fifo_empty) begin
        cdc_data <= fifo[0];
        cdc_valid <= 1'b1;
        fifo_ptr <= fifo_ptr - 1;
        fifo_empty <= (fifo_ptr == 3'b0);
    end
end

// Output Logic
assign read_data = (read_en) ? read_ram[read_addr] : 6'b0;

endmodule