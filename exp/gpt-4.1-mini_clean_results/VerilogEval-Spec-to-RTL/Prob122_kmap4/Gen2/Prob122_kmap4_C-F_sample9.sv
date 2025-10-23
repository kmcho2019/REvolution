module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // The Karnaugh map is indexed by cd (rows) and ab (columns):
    // Output is 1 when the parity of inputs a,b,c,d is odd.
    // Pattern: checkerboard, alternating 0 and 1 for each input change,
    // which exactly matches a 4-input XOR parity function.
    assign out = a ^ b ^ c ^ d;
endmodule