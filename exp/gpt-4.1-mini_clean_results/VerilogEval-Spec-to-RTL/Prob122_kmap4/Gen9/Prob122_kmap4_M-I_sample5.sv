module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Output is parity (XOR) of inputs a, b, c, d, matching the Karnaugh map.
    assign out = a ^ b ^ c ^ d;
endmodule