module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

reg q_reg = 1'b0;

assign q = q_reg;

always @(posedge clk or posedge ar)
    q_reg <= ar ? 1'b0 : d;

endmodule