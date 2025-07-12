module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Internal wires for each output to improve code clarity and synthesis friendliness
    wire and_wire;
    wire or_wire;
    wire xor_wire;

    // 4-input AND: outputs high only if all inputs are 1
    assign and_wire = &in;

    // 4-input OR: outputs high if any input is 1
    assign or_wire  = |in;

    // 4-input XOR: outputs parity (1 if an odd number of bits are set)
    assign xor_wire = ^in;

    // Assign internal wires to outputs
    assign out_and = and_wire;
    assign out_or  = or_wire;
    assign out_xor = xor_wire;

endmodule