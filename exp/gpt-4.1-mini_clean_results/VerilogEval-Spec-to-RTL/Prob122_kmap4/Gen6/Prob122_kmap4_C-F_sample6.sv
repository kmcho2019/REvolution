module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Output is the parity (XOR) of all inputs a, b, c, and d,
    // matching the Karnaugh map pattern exactly.
    assign out = a ^ b ^ c ^ d;
endmodule