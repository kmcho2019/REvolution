module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Optimal minimal XOR parity function implemented as direct continuous assignment for minimal combinational logic
    assign out = a ^ b ^ c ^ d;
endmodule