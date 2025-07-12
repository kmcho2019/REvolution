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

// Directly use write_en and read_en for clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset each memory location explicitly for synthesis efficiency
        RAM[0] <= 6'b0;
        RAM[1] <= 6'b0;
        RAM[2] <= 6'b0;
        RAM[3] <= 6'b0;
        RAM[4] <= 6'b0;
        RAM[5] <= 6'b0;
        RAM[6] <= 6'b0;
        RAM[7] <= 6'b0;
    end else if (write_en) begin
        RAM[write_addr] <= write_data;
    end
end

// Combinatorial logic for read operation, directly assign based on read_en
assign read_data = (read_en) ? RAM[read_addr] : 6'b0;

endmodule