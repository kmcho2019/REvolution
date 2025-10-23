module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Direct continuous assignment of XOR parity function for minimal combinational logic
    assign out = a ^ b ^ c ^ d;
endmodule