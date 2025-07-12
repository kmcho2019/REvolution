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
reg [5:0] write_data_reg;
reg [2:0] write_addr_reg;

// Pipeline stage for write operation
always @(posedge clk) begin
    if (!rst_n) begin
        write_data_reg <= 6'b0;
        write_addr_reg <= 3'b0;
    end else if (write_en) begin
        write_data_reg <= write_data;
        write_addr_reg <= write_addr;
    end
end

// Write operation
always @(posedge clk) begin
    if (!rst_n) begin
        // Reset logic simplified
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b0;
        end
    end else if (write_en) begin
        RAM[write_addr_reg] <= write_data_reg;
    end
end

// Combinatorial logic for read operation
wire [5:0] read_data_comb;
assign read_data_comb = (read_en)? RAM[read_addr] : 6'b0;

// Directly assign read_data_comb to read_data
assign read_data = read_data_comb;

endmodule