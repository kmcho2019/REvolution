module RAM (
    input clk,
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

reg [5:0] RAM [7:0];
reg [5:0] read_data_reg;
reg [2:0] addr_reg;

// Read/Write Controller
always @(posedge clk) begin
    if (!rst_n) begin
        addr_reg <= 3'b0;
    end else if (write_en) begin
        addr_reg <= write_addr;
    end else if (read_en) begin
        addr_reg <= read_addr;
    end
end

// Write operation
always @(posedge clk) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b0;
        end
    end else if (write_en) begin
        RAM[write_addr] <= write_data;
    end
end

// Read operation
always @(posedge clk) begin
    if (!rst_n) begin
        read_data_reg <= 6'b0;
    end else if (read_en) begin
        read_data_reg <= RAM[read_addr];
    end
end

assign read_data = read_data_reg;

endmodule