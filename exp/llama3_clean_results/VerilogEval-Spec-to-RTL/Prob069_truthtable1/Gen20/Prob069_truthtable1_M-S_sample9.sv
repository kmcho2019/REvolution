module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// The existing implementation is recognized as already simplified and efficient.
assign f = (~x3 & x2) | (x3 & x1);

endmodule