module TopModule (
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output       out1,
    output       out2
);

    integer i;

    // Precompute the grouped next_state[0] logic for input=0 to reduce large fan-in:
    // States with transitions to S0 on in=0:
    // S0->S0, S1->S0, S2->S0, S3->S0, S4->S0, S7->S0, S8->S0, S9->S0
    wire zero_in = ~in;
    wire ns0_grouped_zero_in = (
          (state[0] | state[1] | state[2])   // S0,S1,S2
        | (state[3] | state[4])              // S3,S4
        | (state[7] | state[8] | state[9])  // S7,S8,S9
    ) & zero_in;

    always @* begin
        next_state = 10'b0;

        // Assign next_state[0] with grouped zero-in transitions for timing and fan-in optimization
        next_state[0] = ns0_grouped_zero_in;

        // Iterate over all states for input-dependent next state assignments
        for (i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                case (i)
                    0: begin
                        // S0: in=0->S0 handled above; in=1->S1
                        if (in)
                            next_state[1] = 1'b1;
                    end
                    1: begin
                        // S1: in=0->S0 handled above; in=1->S2
                        if (in)
                            next_state[2] = 1'b1;
                    end
                    2: begin
                        // S2: in=0->S0 handled above; in=1->S3
                        if (in)
                            next_state[3] = 1'b1;
                    end
                    3: begin
                        // S3: in=0->S0 handled above; in=1->S4
                        if (in)
                            next_state[4] = 1'b1;
                    end
                    4: begin
                        // S4: in=0->S0 handled above; in=1->S5
                        if (in)
                            next_state[5] = 1'b1;
                    end
                    5: begin
                        // S5: in=0->S8, in=1->S6
                        if (in)
                            next_state[6] = 1'b1;
                        else
                            next_state[8] = 1'b1;
                    end
                    6: begin
                        // S6: in=0->S9, in=1->S7
                        if (in)
                            next_state[7] = 1'b1;
                        else
                            next_state[9] = 1'b1;
                    end
                    7: begin
                        // S7: in=0->S0 handled above; in=1->S7 (self-loop)
                        if (in)
                            next_state[7] = 1'b1;
                    end
                    8: begin
                        // S8: in=0->S0 handled above; in=1->S1
                        if (in)
                            next_state[1] = 1'b1;
                    end
                    9: begin
                        // S9: in=0->S0 handled above; in=1->S1
                        if (in)
                            next_state[1] = 1'b1;
                    end
                    default: ;
                endcase
            end
        end
    end

    // Output logic depends only on the current state bits:
    // out1 = 1 if S8 or S9 active (state[8] or state[9])
    // out2 = 1 if S7 or S9 active (state[7] or state[9])
    localparam [9:0] MASK_OUT1 = (1 << 8) | (1 << 9);
    localparam [9:0] MASK_OUT2 = (1 << 7) | (1 << 9);

    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2);

endmodule