module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    reg [9:0] next_state_reg;
    integer   idx;

    always @* begin
        next_state_reg = 10'b0;

        // Accumulate next_state bits for all active states
        for (idx = 0; idx < 10; idx = idx + 1) begin
            if (state[idx]) begin
                case (idx)
                    0: next_state_reg[in ? 1 : 0] = 1'b1;     // S0: in=0->S0, in=1->S1
                    1: next_state_reg[in ? 2 : 0] = 1'b1;     // S1: in=0->S0, in=1->S2
                    2: next_state_reg[in ? 3 : 0] = 1'b1;     // S2: in=0->S0, in=1->S3
                    3: next_state_reg[in ? 4 : 0] = 1'b1;     // S3: in=0->S0, in=1->S4
                    4: next_state_reg[in ? 5 : 0] = 1'b1;     // S4: in=0->S0, in=1->S5
                    5: next_state_reg[in ? 6 : 8] = 1'b1;     // S5: in=0->S8, in=1->S6
                    6: next_state_reg[in ? 7 : 9] = 1'b1;     // S6: in=0->S9, in=1->S7
                    7: next_state_reg[in ? 7 : 0] = 1'b1;     // S7: in=0->S0, in=1->S7
                    8: next_state_reg[in ? 1 : 0] = 1'b1;     // S8: in=0->S0, in=1->S1
                    9: next_state_reg[in ? 1 : 0] = 1'b1;     // S9: in=0->S0, in=1->S1
                    default: ;
                endcase
            end
        end
    end

    // Outputs determined by which current states are active, independent of input for outputs,
    // as outputs are defined per state regardless of input (except S7/S8/S9)
    // out1 is 1 if S8 or S9 active
    // out2 is 1 if S7 or S9 active

    wire out1_wire = (| (state & 10'b0000001100_000)); // state[8] or state[9]
    wire out2_wire = (| (state & 10'b1000001000_000)); // state[7] or state[9]

    // Explicitly expand the above masks (state bits 7,8,9):
    // state[7] = 10'b0000001000 = 8 decimal bit
    // state[8] = 10'b0000010000 = 16 decimal bit
    // state[9] = 10'b0000100000 = 32 decimal bit
    // Let's fix the masks for 10 bits: bits 7,8,9 corresponds to bit7=1<<7=128, bit8=1<<8=256, bit9=1<<9=512
    // So:
    // out1 = state[8] or state[9] = (state & (1<<8 | 1<<9))
    // out2 = state[7] or state[9] = (state & (1<<7 | 1<<9))

    wire out1_comb = |(state & (10'b0000001100_0000)); // incorrect length, fix below

    // Correct masks for 10 bits (bit9 is MSB at index 9)
    // 1 << 7 = 128 decimal = 10'b0001000000
    // 1 << 8 = 256 decimal = 10'b0010000000
    // 1 << 9 = 512 decimal = 10'b0100000000

    // So for 10 bits: (index from 0 to 9)
    // state bits:
    // 0: bit0 = 1
    // 7: bit7 = 1 << 7 = 128 (10'b0010000000)
    // Actually, binary literal for 10 bits:
    // bit7 = 1 << 7 = 128 = 10'b0010000000 (from MSB 9 to LSB 0)
    // bit8 = 1 << 8 = 256 = 10'b0100000000
    // bit9 = 1 << 9 = 512 = 10'b1000000000

    // Masks:
    localparam [9:0] mask_out1 = (1 << 8) | (1 << 9); // bits 8 and 9
    localparam [9:0] mask_out2 = (1 << 7) | (1 << 9); // bits 7 and 9

    assign out1 = |(state & mask_out1);
    assign out2 = |(state & mask_out2);

    assign next_state = next_state_reg;

endmodule