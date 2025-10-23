module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // For each state Si (i=0..9), define the next state vector based on input 'in'
    // This function returns a 10-bit one-hot vector corresponding to the next state(s)
    function [9:0] next_state_for_single_state;
        input integer idx;
        input        in_bit;
        begin
            case (idx)
                0: next_state_for_single_state = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000000010; // S0->S0 or S1
                1: next_state_for_single_state = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000000100; // S1->S0 or S2
                2: next_state_for_single_state = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000001000; // S2->S0 or S3
                3: next_state_for_single_state = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000010000; // S3->S0 or S4
                4: next_state_for_single_state = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000100000; // S4->S0 or S5
                5: next_state_for_single_state = (in_bit == 1'b0) ? 10'b0000010000000 : 10'b0001000000; // S5->S8 or S6
                6: next_state_for_single_state = (in_bit == 1'b0) ? 10'b1000000000 : 10'b0100000000; // S6->S9 or S7
                7: next_state_for_single_state = (in_bit == 1'b0) ? 10'b0000000001 : 10'b10000000; // S7->S0 or S7 (need 10-bit constant)
                8: next_state_for_single_state = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000000010; // S8->S0 or S1
                9: next_state_for_single_state = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000000010; // S9->S0 or S1
                default: next_state_for_single_state = 10'b0;
            endcase
        end
    endfunction

    // Due to a typo, fix bit widths:
    // Let's rewrite the constants properly with 10-bit widths:

    // So fix the function below.

    function [9:0] next_state_for_single_state_fixed;
        input integer idx;
        input        in_bit;
        begin
            case (idx)
                0: next_state_for_single_state_fixed = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000000010; // S0->S0 or S1
                1: next_state_for_single_state_fixed = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000000100; // S1->S0 or S2
                2: next_state_for_single_state_fixed = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000001000; // S2->S0 or S3
                3: next_state_for_single_state_fixed = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000010000; // S3->S0 or S4
                4: next_state_for_single_state_fixed = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000100000; // S4->S0 or S5
                5: next_state_for_single_state_fixed = (in_bit == 1'b0) ? 10'b0010000000 : 10'b0001000000; // S5->S8 or S6 (S8=bit8, S6=bit6)
                6: next_state_for_single_state_fixed = (in_bit == 1'b0) ? 10'b1000000000 : 10'b0100000000; // S6->S9 or S7 (S9=bit9, S7=bit7)
                7: next_state_for_single_state_fixed = (in_bit == 1'b0) ? 10'b0000000001 : 10'b00000010000000 >> 7; // S7->S0 or S7, here fix below
                8: next_state_for_single_state_fixed = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000000010; // S8->S0 or S1
                9: next_state_for_single_state_fixed = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000000010; // S9->S0 or S1
                default: next_state_for_single_state_fixed = 10'b0;
            endcase
        end
    endfunction

    // Manually fix line for S7: 
    // S7 --0--> S0 = bit0
    // S7 --1--> S7 = bit7
    // So next_state_for_single_state_fixed(7,0) = 10'b0000000001
    // next_state_for_single_state_fixed(7,1) = 10'b0000001000 (bit7 is index 7)
    // binary literal for bit7 = 1 << 7 = 10'b00000010000000 (too long, 14 bits)
    // 10 bits: bit7 is the 8th bit from right (count from 0)

    // 1 << 7 = 8'h80 = 10'b00000010000000 - no, that's 12 bits, the 10 bits are indexed 9..0
    // The bits are: bit0 = LSB, bit9 = MSB
    // So 1 << 7 = 10'b0010000000

    // Corrected 1 << 7 = 10'b0010000000

    // So final for S7:
    // in==0: 10'b0000000001
    // in==1: 10'b0010000000

    // Now final version of the function:

    function [9:0] next_state_for_single_state_fn;
        input integer idx;
        input        in_bit;
        begin
            case (idx)
                0: next_state_for_single_state_fn = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000000010; // S0->S0 or S1
                1: next_state_for_single_state_fn = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000000100; // S1->S0 or S2
                2: next_state_for_single_state_fn = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000001000; // S2->S0 or S3
                3: next_state_for_single_state_fn = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000010000; // S3->S0 or S4
                4: next_state_for_single_state_fn = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000100000; // S4->S0 or S5
                5: next_state_for_single_state_fn = (in_bit == 1'b0) ? 10'b0010000000 : 10'b0001000000; // S5->S8 or S6 (bit8 or bit6)
                6: next_state_for_single_state_fn = (in_bit == 1'b0) ? 10'b1000000000 : 10'b0100000000; // S6->S9 or S7 (bit9 or bit7)
                7: next_state_for_single_state_fn = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0010000000; // S7->S0 or S7
                8: next_state_for_single_state_fn = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000000010; // S8->S0 or S1
                9: next_state_for_single_state_fn = (in_bit == 1'b0) ? 10'b0000000001 : 10'b0000000010; // S9->S0 or S1
                default: next_state_for_single_state_fn = 10'b0;
            endcase
        end
    endfunction

    // Now generate per-state contributions and OR them for next_state
    wire [9:0] next_state_vecs [0:9];
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : gen_next_state_vecs
            assign next_state_vecs[i] = state[i] ? next_state_for_single_state_fn(i, in) : 10'b0;
        end
    endgenerate

    // OR all next_state_vecs together
    assign next_state = next_state_vecs[0]
                      | next_state_vecs[1]
                      | next_state_vecs[2]
                      | next_state_vecs[3]
                      | next_state_vecs[4]
                      | next_state_vecs[5]
                      | next_state_vecs[6]
                      | next_state_vecs[7]
                      | next_state_vecs[8]
                      | next_state_vecs[9];

    // Outputs: as before
    // out1 = 1 if state includes S8 or S9
    // out2 = 1 if state includes S7 or S9

    assign out1 = |(state & 10'b1100000000); // bits 9 or 8
    assign out2 = |(state & 10'b0100001000); // bits 9 or 7 (bit 7=1<<7=128 decimal = 10'b0010000000), bit9=1<<9=512 decimal=10'b1000000000
    // So mask for out2: bits 9 and 7 = 10'b1010000000 = 0x280
    // Actually 10'b0100001000 means bits 9 and 7? Let's write carefully:
    // bit9 = 1<<9 = 10'b1000000000 = 512 decimal
    // bit7 = 1<<7 = 10'b0010000000 = 128 decimal
    // So mask = 10'b1010000000 = (512+128)=640 decimal

    // So:
    // out1 mask: bits 9 and 8 = (1<<9)|(1<<8) = 512+256=768 decimal = 10'b1100000000
    // out2 mask: bits 9 and 7 = 512+128=640 decimal = 10'b1010000000

    assign out1 = |(state & 10'b1100000000); // bits 9,8
    assign out2 = |(state & 10'b1010000000); // bits 9,7

endmodule