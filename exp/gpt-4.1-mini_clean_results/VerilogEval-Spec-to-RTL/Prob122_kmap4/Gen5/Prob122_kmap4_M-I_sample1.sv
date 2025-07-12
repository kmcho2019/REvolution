module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Direct XOR of all inputs for parity function matching the Karnaugh map.
    assign out = a ^ b ^ c ^ d;

endmodule