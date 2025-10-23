module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// The output corresponds to the XOR of all four inputs.
// This directly matches the given Karnaugh map pattern,
// where output is 1 if the number of 1's in inputs (a,b,c,d) is odd.
// Thus, out = a ^ b ^ c ^ d.

assign out = a ^ b ^ c ^ d;

endmodule