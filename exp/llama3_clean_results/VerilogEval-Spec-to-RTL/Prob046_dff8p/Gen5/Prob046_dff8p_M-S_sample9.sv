module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

always @(negedge clk) 
    q_reg <= reset ? 8'h34 : d;

assign q = q_reg;

endmodule