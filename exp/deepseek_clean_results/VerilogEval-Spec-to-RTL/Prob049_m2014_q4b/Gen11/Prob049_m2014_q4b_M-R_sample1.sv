module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

reg q_reg = 1'b0;

always @(posedge clk or posedge ar)
    if (ar) q_reg <= 1'b0;
    else    q_reg <= d;

assign q = q_reg;

endmodule