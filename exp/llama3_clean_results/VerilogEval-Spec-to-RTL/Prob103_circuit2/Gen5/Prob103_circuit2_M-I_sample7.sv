module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// The current implementation is already quite straightforward and efficient.
// To optimize further, we could consider using a single line for the assign statement,
// but this does not significantly impact the PPA metrics in this simple case.
assign q = ~(a ^ b ^ c ^ d);

endmodule