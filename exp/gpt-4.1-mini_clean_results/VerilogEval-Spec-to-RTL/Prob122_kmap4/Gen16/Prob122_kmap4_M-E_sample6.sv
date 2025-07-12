module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire xor1;
    wire xor2;

    // XOR pairs of inputs
    assign xor1 = a ^ b;
    assign xor2 = c ^ d;

    // Final XOR of intermediate results
    assign out = xor1 ^ xor2;
endmodule