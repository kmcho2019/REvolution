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

reg [WIDTH-1:0] RAM [DEPTH-1:0];
reg [WIDTH-1:0] read_data_reg;

// Write operation pipeline stage 1: address decoding
reg [2:0] write_addr_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        write_addr_reg <= 3'b000;
    end else if (write_en) begin
        write_addr_reg <= write_addr;
    end
end

// Write operation pipeline stage 2: data writing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= {WIDTH{1'b0}};
        end
    end else if (write_en) begin
        RAM[write_addr_reg] <= write_data;
    end
end

// Asynchronous read operation using CAM-style approach
always @(read_en or read_addr) begin
    if (read_en) begin
        read_data_reg = RAM[read_addr];
    end else begin
        read_data_reg = {WIDTH{1'b0}};
    end
end

// Dynamic power management system
reg power_en;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        power_en <= 1'b0;
    end else if (write_en || read_en) begin
        power_en <= 1'b1;
    end else begin
        power_en <= 1'b0;
    end
end

// Power supply adjustment based on activity level
assign power_supply = power_en ? 1'b1 : 1'b0;

assign read_data = read_data_reg;

endmodule