module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Minimal XOR parity logic with continuous assignment for optimal combinational implementation
    assign out = a ^ b ^ c ^ d;
endmodule