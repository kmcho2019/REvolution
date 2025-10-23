module TopModule (
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output       out1,
    output       out2
);

    // Localparams for output masks (states producing outputs)
    localparam [9:0] OUT1_MASK = 10'b1100000000; // S8 (bit8), S9 (bit9)
    localparam [9:0] OUT2_MASK = (1 << 7) | (1 << 9); // S7 (bit7), S9 (bit9)

    // States transitioning to S0 on input=0 for balanced hierarchical OR:
    // S0(0), S1(1), S2(2), S3(3), S4(4), S7(7), S8(8), S9(9)
    wire zero_in = ~in;
    wire one_in  =  in;
    wire groupA = state[0] | state[1] | state[2];   // S0, S1, S2
    wire groupB = state[3] | state[4];              // S3, S4
    wire groupC = state[7] | state[8] | state[9];   // S7, S8, S9

    // next_state[0] optimized with balanced OR tree and input 0
    wire next0_from_zero = (groupA | groupB | groupC) & zero_in;

    integer i;

    always @* begin
        // Initialize next_state with next_state[0] assigned from optimized OR,
        // other bits cleared (0)
        next_state = 10'b0;
        next_state[0] = next0_from_zero;

        // For all other next_state bits, accumulate transitions per active state
        for (i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                case (i)
                    0: next_state[1] = next_state[1] | one_in;       // S0: input=1 -> S1
                    1: next_state[2] = next_state[2] | one_in;       // S1: input=1 -> S2
                    2: next_state[3] = next_state[3] | one_in;       // S2: input=1 -> S3
                    3: next_state[4] = next_state[4] | one_in;       // S3: input=1 -> S4
                    4: next_state[5] = next_state[5] | one_in;       // S4: input=1 -> S5
                    5: begin                                         // S5: 0->S8, 1->S6
                        if (in) next_state[6] = 1'b1;
                        else     next_state[8] = 1'b1;
                    end
                    6: begin                                         // S6: 0->S9, 1->S7
                        if (in) next_state[7] = 1'b1;
                        else     next_state[9] = 1'b1;
                    end
                    7: begin                                         // S7: 0->S0, 1->S7
                        if (in) next_state[7] = 1'b1;
                        else     next_state[0] = 1'b1;
                    end
                    8: next_state[1] = next_state[1] | one_in;       // S8: 1->S1
                    9: next_state[1] = next_state[1] | one_in;       // S9: 1->S1
                    default: ; // no transitions
                endcase
            end
        end
    end

    // Outputs active if any active state in their respective masks
    assign out1 = |(state & OUT1_MASK);
    assign out2 = |(state & OUT2_MASK);

endmodule