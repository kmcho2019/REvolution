module TopModule (
    input wire x,
    input wire y,
    output wire z
);

    wire xor_out;

    // XOR gate: xor_out = x ^ y
    xor xor_gate (xor_out, x, y);

    // AND gate: z = xor_out & x
    and and_gate (z, xor_out, x);

endmodule