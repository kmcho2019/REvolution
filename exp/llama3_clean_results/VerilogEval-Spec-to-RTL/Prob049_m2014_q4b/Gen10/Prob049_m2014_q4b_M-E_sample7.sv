module TopModule(
    input clk,
    input ar,
    input d,
    output q
);

reg q_int;

always @(posedge ar or posedge clk)
    if (ar) q_int <= 1'b0;
    else if (clk) q_int <= d;

assign q = q_int;

endmodule