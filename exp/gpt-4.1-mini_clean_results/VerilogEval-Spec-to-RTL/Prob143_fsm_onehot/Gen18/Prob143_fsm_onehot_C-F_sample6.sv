module TopModule(
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // Hierarchical OR-tree for next_state[0] (S0)
    // States that transition to S0 on input=0:
    // S0, S1, S2, S3, S4, S7, S8, S9
    // Group these to limit fan-in:
    wire groupA = state[0] | state[1] | state[2];       // S0, S1, S2
    wire groupB = state[3] | state[4];                  // S3, S4
    wire groupC = state[7] | state[8] | state[9];       // S7, S8, S9
    wire ns0_zero = (groupA | groupB | groupC) & zero_in;

    // Combinational always block for other next_state bits
    integer i;
    reg [9:0] next_state_temp;

    always @* begin
        next_state_temp = 10'b0; // Clear all next states initially

        for (i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                case (i)
                    0: begin
                        // S0: on 1 -> S1, 0 -> S0 (handled separately for 0)
                        if (one_in)
                            next_state_temp[1] = 1'b1;
                    end
                    1: begin
                        // S1: 1->S2, 0->S0 (0 handled separately)
                        if (one_in)
                            next_state_temp[2] = 1'b1;
                    end
                    2: begin
                        // S2: 1->S3, 0->S0 (0 handled separately)
                        if (one_in)
                            next_state_temp[3] = 1'b1;
                    end
                    3: begin
                        // S3: 1->S4, 0->S0 (0 handled separately)
                        if (one_in)
                            next_state_temp[4] = 1'b1;
                    end
                    4: begin
                        // S4: 1->S5, 0->S0 (0 handled separately)
                        if (one_in)
                            next_state_temp[5] = 1'b1;
                    end
                    5: begin
                        // S5: 1->S6, 0->S8
                        if (one_in)
                            next_state_temp[6] = 1'b1;
                        else
                            next_state_temp[8] = 1'b1;
                    end
                    6: begin
                        // S6: 1->S7, 0->S9
                        if (one_in)
                            next_state_temp[7] = 1'b1;
                        else
                            next_state_temp[9] = 1'b1;
                    end
                    7: begin
                        // S7: 1->S7, 0->S0 (0 handled separately)
                        if (one_in)
                            next_state_temp[7] = 1'b1;
                    end
                    8: begin
                        // S8: 1->S1, 0->S0 (0 handled separately)
                        if (one_in)
                            next_state_temp[1] = 1'b1;
                    end
                    9: begin
                        // S9: 1->S1, 0->S0 (0 handled separately)
                        if (one_in)
                            next_state_temp[1] = 1'b1;
                    end
                    default: begin end
                endcase
            end
        end
    end

    // Final assignment including next_state[0] from hierarchical OR-tree for zero_in transitions
    always @* begin
        next_state = next_state_temp;
        next_state[0] = ns0_zero;
    end

    // Outputs
    // out1 active for states S8 or S9
    assign out1 = state[8] | state[9];

    // out2 active for states S7 or S9
    assign out2 = state[7] | state[9];

endmodule