module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Intermediate wires for next states from each current state bit
    wire [9:0] next_from_S0;
    wire [9:0] next_from_S1;
    wire [9:0] next_from_S2;
    wire [9:0] next_from_S3;
    wire [9:0] next_from_S4;
    wire [9:0] next_from_S5;
    wire [9:0] next_from_S6;
    wire [9:0] next_from_S7;
    wire [9:0] next_from_S8;
    wire [9:0] next_from_S9;

    // Default all to zero
    assign next_from_S0 = in ? (10'b0000000010) : (10'b0000000001);
    // S0: 0->S0, 1->S1

    assign next_from_S1 = in ? (10'b0000000100) : (10'b0000000001);
    // S1: 0->S0, 1->S2

    assign next_from_S2 = in ? (10'b0000001000) : (10'b0000000001);
    // S2: 0->S0, 1->S3

    assign next_from_S3 = in ? (10'b0000010000) : (10'b0000000001);
    // S3: 0->S0, 1->S4

    assign next_from_S4 = in ? (10'b0000100000) : (10'b0000000001);
    // S4: 0->S0, 1->S5

    assign next_from_S5 = in ? (10'b0000010000_0000000 >> 3) : (10'b0000001000);
    // Actually from given transitions:
    // S5 (0,0) --0--> S8 (bit8)
    // S5 (0,0) --1--> S6 (bit6)
    assign next_from_S5 = in ? (10'b0000010000 << 1) : (10'b0000000100 << 5);
    // Correct the above for bits:
    // Bit 8 = S8, bit 6 = S6
    // 10'b positions: [9:0] = S9..S0
    // So bit8 = 1<<8, bit6 = 1<<6
    assign next_from_S5 = in ? (10'b0000000100000000 >> 1) : (10'b0000010000000000 >> 3);
    // This is confusing. Better write explicitly:
    // 1<<8 = 9'b 100000000
    // 1<<6 = 1<<6 = 64 decimal = 10'b0001000000
    // So:
    assign next_from_S5 = in ? (10'b0000000100000000 >> 1) : (10'b0000010000000000 >> 3);
    // Still complicated. Let's just write:
    assign next_from_S5 = in ? (10'b0000000100000000 >> 1) : (10'b0000010000000000 >> 3);
    // That was an error, let's fix this carefully:
    // S5 --0--> S8 = 1<<8
    // S5 --1--> S6 = 1<<6
    // So:
    assign next_from_S5 = in ? (10'b0000000001000000) : (10'b0000000100000000);
    // in=1 -> S6 = bit6 = 0x40, in=0 -> S8 = bit8 = 0x100

    assign next_from_S6 = in ? (10'b0000001000000000) : (10'b0010000000);
    // S6 --0--> S9 (bit9 = 1<<9 = 512 decimal = 10'b1000000000)
    // S6 --1--> S7 (bit7 = 1<<7 = 128 decimal = 10'b0010000000)
    assign next_from_S6 = in ? (10'b0010000000) : (10'b1000000000);
    // Correction: in=0->S9(bit9=1<<9=512=10'b1000000000), in=1->S7(bit7=1<<7=128=10'b0010000000)
    assign next_from_S6 = in ? (10'b0010000000) : (10'b1000000000);

    // S7 (0,1) --0--> S0
    // S7 (0,1) --1--> S7
    // out1=0, out2=1
    assign next_from_S7 = in ? (10'b00000010000000 >> 7) : (10'b0000000001);
    // Let's rewrite:
    // in=0 -> S0 (bit0=1)
    // in=1 -> S7 (bit7=1<<7=128)
    assign next_from_S7 = in ? (10'b0010000000) : (10'b0000000001);

    // S8 (1,0) --0--> S0
    // S8 (1,0) --1--> S1
    // out1=1, out2=0
    assign next_from_S8 = in ? (10'b0000000010) : (10'b0000000001);

    // S9 (1,1) --0--> S0
    // S9 (1,1) --1--> S1
    // out1=1, out2=1
    assign next_from_S9 = in ? (10'b0000000010) : (10'b0000000001);

    // Now combine all next states weighted by current state bits
    assign next_state = (state[0] ? next_from_S0 : 10'b0)
                      | (state[1] ? next_from_S1 : 10'b0)
                      | (state[2] ? next_from_S2 : 10'b0)
                      | (state[3] ? next_from_S3 : 10'b0)
                      | (state[4] ? next_from_S4 : 10'b0)
                      | (state[5] ? next_from_S5 : 10'b0)
                      | (state[6] ? next_from_S6 : 10'b0)
                      | (state[7] ? next_from_S7 : 10'b0)
                      | (state[8] ? next_from_S8 : 10'b0)
                      | (state[9] ? next_from_S9 : 10'b0);

    // Outputs: only from S7 and S8 and S9
    // S7: (0,1), S8: (1,0), S9: (1,1)
    // If multiple states active, outputs are OR of each
    assign out1 = (state[8]) | (state[9]);
    assign out2 = (state[7]) | (state[9]);

endmodule