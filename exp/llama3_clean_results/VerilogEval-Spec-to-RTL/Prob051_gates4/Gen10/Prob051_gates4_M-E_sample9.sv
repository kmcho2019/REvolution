module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    // Internal wires for AND, OR, and XOR operations
    wire and_out, or_out, xor_out;

    // AND operation
    assign and_out = in[3] & in[2] & in[1] & in[0];

    // OR operation
    assign or_out = in[3] | in[2] | in[1] | in[0];

    // XOR operation
    assign xor_out = in[3] ^ in[2] ^ in[1] ^ in[0];

    // Assign the computed values to the outputs
    assign out_and = and_out;
    assign out_or = or_out;
    assign out_xor = xor_out;
endmodule