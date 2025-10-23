module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    reg [9:0] next_state_reg;
    reg       next_state0_from_S0_S1_S2;
    reg       next_state0_from_S3_S4;
    reg       next_state0_from_S7_S8_S9;
    integer   i;

    always @* begin
        next_state_reg = 10'b0;

        // Temporary accumulators for balanced OR grouping of next_state[0]
        next_state0_from_S0_S1_S2 = 1'b0;
        next_state0_from_S3_S4     = 1'b0;
        next_state0_from_S7_S8_S9 = 1'b0;

        for (i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                case (i)
                    0: begin
                        // S0: input=0 -> S0, input=1 -> S1
                        if (!in)
                            next_state0_from_S0_S1_S2 = 1'b1; // belongs to group A
                        else
                            next_state_reg[1] = 1'b1;
                    end
                    1: begin
                        // S1: input=0 -> S0, input=1 -> S2
                        if (!in)
                            next_state0_from_S0_S1_S2 = 1'b1;
                        else
                            next_state_reg[2] = 1'b1;
                    end
                    2: begin
                        // S2: input=0 -> S0, input=1 -> S3
                        if (!in)
                            next_state0_from_S0_S1_S2 = 1'b1;
                        else
                            next_state_reg[3] = 1'b1;
                    end
                    3: begin
                        // S3: input=0 -> S0, input=1 -> S4
                        if (!in)
                            next_state0_from_S3_S4 = 1'b1; // group B
                        else
                            next_state_reg[4] = 1'b1;
                    end
                    4: begin
                        // S4: input=0 -> S0, input=1 -> S5
                        if (!in)
                            next_state0_from_S3_S4 = 1'b1;
                        else
                            next_state_reg[5] = 1'b1;
                    end
                    5: begin
                        // S5: input=0 -> S8, input=1 -> S6
                        if (!in)
                            next_state_reg[8] = 1'b1;
                        else
                            next_state_reg[6] = 1'b1;
                    end
                    6: begin
                        // S6: input=0 -> S9, input=1 -> S7
                        if (!in)
                            next_state_reg[9] = 1'b1;
                        else
                            next_state_reg[7] = 1'b1;
                    end
                    7: begin
                        // S7: input=0 -> S0, input=1 -> S7
                        if (!in)
                            next_state0_from_S7_S8_S9 = 1'b1; // group C
                        else
                            next_state_reg[7] = 1'b1;
                    end
                    8: begin
                        // S8: input=0 -> S0, input=1 -> S1
                        if (!in)
                            next_state0_from_S7_S8_S9 = 1'b1;
                        else
                            next_state_reg[1] = 1'b1;
                    end
                    9: begin
                        // S9: input=0 -> S0, input=1 -> S1
                        if (!in)
                            next_state0_from_S7_S8_S9 = 1'b1;
                        else
                            next_state_reg[1] = 1'b1;
                    end
                endcase
            end
        end

        // Balanced hierarchical OR grouping for next_state[0]
        next_state_reg[0] = next_state0_from_S0_S1_S2 | next_state0_from_S3_S4 | next_state0_from_S7_S8_S9;
    end

    // Output logic: outputs depend on the union of states that produce them
    // out1 = 1 if state S8 or S9 is active
    // out2 = 1 if state S7 or S9 is active
    localparam [9:0] OUT1_MASK = (1 << 8) | (1 << 9);
    localparam [9:0] OUT2_MASK = (1 << 7) | (1 << 9);

    assign out1 = |(state & OUT1_MASK);
    assign out2 = |(state & OUT2_MASK);

    assign next_state = next_state_reg;

endmodule