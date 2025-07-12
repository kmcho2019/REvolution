module TopModule (
    input  [3:0] in,
    output [1:0] pos
);
    // pos[0] is set if bit 0 is set or if bit 2 is set (because pos=2 for bit 2)
    // pos[1] is set if bit 2 or bit 3 is set (positions 2 or 3)
    assign pos[0] = in[0] | in[2];
    assign pos[1] = in[2] | in[3];

    // To ensure priority encoding, mask the lower priority bits
    // We must encode the first set bit only:
    // priority order: bit0 > bit1 > bit2 > bit3
    // So output should represent the index of the first high bit.

    // Let's compute a "valid" signal per bit indicating if this bit is the first set bit:
    wire bit0_valid = in[0];
    wire bit1_valid = ~in[0] & in[1];
    wire bit2_valid = ~in[0] & ~in[1] & in[2];
    wire bit3_valid = ~in[0] & ~in[1] & ~in[2] & in[3];

    // Now encode pos from valid bits:
    assign pos = (bit0_valid) ? 2'd0 :
                 (bit1_valid) ? 2'd1 :
                 (bit2_valid) ? 2'd2 :
                 (bit3_valid) ? 2'd3 :
                 2'd0; // default zero if none set

endmodule