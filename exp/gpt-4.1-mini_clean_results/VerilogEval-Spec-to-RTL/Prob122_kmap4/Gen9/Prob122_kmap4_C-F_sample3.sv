module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Output is the XOR parity of inputs a, b, c, and d,
    // matching the given Karnaugh map pattern.
    assign out = a ^ b ^ c ^ d;
endmodule