module TopModule (
    input  a,
    input  b,
    input  c,
    input  d, // don't-care input, unused in logic
    output out
);

// The output is high if 'a' is high, or if 'c' is high and 'b' is low.
// The input 'd' is don't-care and ignored to simplify logic.
assign out = a | (c & ~b);

endmodule