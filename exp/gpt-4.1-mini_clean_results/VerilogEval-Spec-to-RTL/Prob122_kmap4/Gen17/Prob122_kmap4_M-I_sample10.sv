module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Direct 4-input XOR expression for parity function
    assign out = a ^ b ^ c ^ d;
endmodule