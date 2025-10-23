// The original implementation is already quite optimized for the given Karnaugh map.
// Therefore, without additional context or requirements, the improved code remains the same as the original.
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = a ? 1'b1 : (c ? !b : 1'b0);

endmodule