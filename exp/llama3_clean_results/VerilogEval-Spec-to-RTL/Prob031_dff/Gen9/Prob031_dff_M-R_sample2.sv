module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_reg;

always @(posedge clk)
    q_reg <= d;

assign q = q_reg;

endmodule