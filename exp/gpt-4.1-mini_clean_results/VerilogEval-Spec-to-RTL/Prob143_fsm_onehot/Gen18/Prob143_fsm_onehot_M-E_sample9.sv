module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);
    // Declare wires for next state contributions from each current state.
    // Each is a 10-bit one-hot vector with exactly one bit set if active.
    wire [9:0] next_from_S [9:0];

    // For input signal convenience
    wire zero = ~in;
    wire one  =  in;

    // State S0
    assign next_from_S[0] = state[0] ? (zero ? 10'b0000000001 : 10'b0000000010) : 10'b0;
    // S0 --0--> S0 (bit0), --1--> S1 (bit1)

    // State S1
    assign next_from_S[1] = state[1] ? (zero ? 10'b0000000001 : 10'b0000000100) : 10'b0;
    // S1 --0--> S0, --1--> S2

    // State S2
    assign next_from_S[2] = state[2] ? (zero ? 10'b0000000001 : 10'b0000001000) : 10'b0;
    // S2 --0--> S0, --1--> S3

    // State S3
    assign next_from_S[3] = state[3] ? (zero ? 10'b0000000001 : 10'b0000010000) : 10'b0;
    // S3 --0--> S0, --1--> S4

    // State S4
    assign next_from_S[4] = state[4] ? (zero ? 10'b0000000001 : 10'b0000100000) : 10'b0;
    // S4 --0--> S0, --1--> S5

    // State S5
    assign next_from_S[5] = state[5] ? (zero ? 10'b0000010000_000 : 10'b0001000000) : 10'b0;
    // S5 --0--> S8(bit8), --1--> S6(bit6)
    // Note: 10'b0000010000_000 means bit8, need to write 10'b1000000000 (bit8)
    // Correction: 10 bits indexed 9..0
    // bit8 is 1<<8 = 9'b100000000 = 10'b0100000000
    // Actually bit8 = 1<<8 = 256 = 10'b0100000000
    // Let's explicitly use (1<<8) = 10'b0100000000

    assign next_from_S[5] = state[5] ? (zero ? (10'b1 << 8) : (10'b1 << 6)) : 10'b0;
    // S5 --0--> S8, --1--> S6

    // State S6
    assign next_from_S[6] = state[6] ? (zero ? (10'b1 << 9) : (10'b1 << 7)) : 10'b0;
    // S6 --0--> S9(bit9), --1--> S7(bit7)

    // State S7
    assign next_from_S[7] = state[7] ? (zero ? 10'b0000000001 : 10'b0000001000_000) : 10'b0;
    // S7 --0--> S0, --1--> S7
    // bit7 is 1<<7 = 128 = 10'b0001000000
    assign next_from_S[7] = state[7] ? (zero ? 10'b0000000001 : (10'b1 << 7)) : 10'b0;

    // State S8
    assign next_from_S[8] = state[8] ? (zero ? 10'b0000000001 : 10'b0000000010) : 10'b0;
    // S8 --0--> S0, --1--> S1

    // State S9
    assign next_from_S[9] = state[9] ? (zero ? 10'b0000000001 : 10'b0000000010) : 10'b0;
    // S9 --0--> S0, --1--> S1

    // Combine all partial next states with bitwise OR
    assign next_state = next_from_S[0] | next_from_S[1] | next_from_S[2] | next_from_S[3]
                      | next_from_S[4] | next_from_S[5] | next_from_S[6] | next_from_S[7]
                      | next_from_S[8] | next_from_S[9];

    // Outputs
    // S7 output (0,1), S8 (1,0), S9 (1,1), rest zero
    assign out1 = (state[8] | state[9]);
    assign out2 = (state[7] | state[9]);

endmodule