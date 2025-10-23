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

// Combinatorial logic for read operation
assign read_data = (read_en) ? RAM[read_addr] : 6'b0;

// Sequential block for reset
always @(negedge rst_n) begin
    // Reset logic
    for (int i = 0; i < DEPTH; i++) begin
        RAM[i] <= 6'b0;
    end
    read_data_reg <= 6'b0;
end

// Sequential block for write operation
always @(posedge clk) begin
    if (write_en) begin
        RAM[write_addr] <= write_data;
    end
end

endmodule