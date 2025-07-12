module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg internal_q;

always @(posedge clk or posedge ar)
    if (ar) internal_q <= 1'b0; else internal_q <= d;

assign q = internal_q;

endmodule