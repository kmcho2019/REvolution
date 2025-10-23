module TopModule(
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output reg       out1,
    output reg       out2
);

    integer i;
    reg [9:0] next_state_comb;
    reg out1_comb, out2_comb;

    always @* begin
        // Default values
        next_state_comb = 10'b0;
        out1_comb = 1'b0;
        out2_comb = 1'b0;

        // For each possible active state, update next_state bits and outputs
        for (i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                case (i)
                    0: begin // S0
                        if (in == 1'b0)
                            next_state_comb[0] = 1'b1; // S0 -> S0 on 0
                        else
                            next_state_comb[1] = 1'b1; // S0 -> S1 on 1
                    end
                    1: begin // S1
                        if (in == 1'b0)
                            next_state_comb[0] = 1'b1; // S1 -> S0 on 0
                        else
                            next_state_comb[2] = 1'b1; // S1 -> S2 on 1
                    end
                    2: begin // S2
                        if (in == 1'b0)
                            next_state_comb[0] = 1'b1; // S2 -> S0 on 0
                        else
                            next_state_comb[3] = 1'b1; // S2 -> S3 on 1
                    end
                    3: begin // S3
                        if (in == 1'b0)
                            next_state_comb[0] = 1'b1; // S3 -> S0 on 0
                        else
                            next_state_comb[4] = 1'b1; // S3 -> S4 on 1
                    end
                    4: begin // S4
                        if (in == 1'b0)
                            next_state_comb[0] = 1'b1; // S4 -> S0 on 0
                        else
                            next_state_comb[5] = 1'b1; // S4 -> S5 on 1
                    end
                    5: begin // S5
                        if (in == 1'b0)
                            next_state_comb[8] = 1'b1; // S5 -> S8 on 0
                        else
                            next_state_comb[6] = 1'b1; // S5 -> S6 on 1
                    end
                    6: begin // S6
                        if (in == 1'b0)
                            next_state_comb[9] = 1'b1; // S6 -> S9 on 0
                        else
                            next_state_comb[7] = 1'b1; // S6 -> S7 on 1
                    end
                    7: begin // S7
                        if (in == 1'b0)
                            next_state_comb[0] = 1'b1; // S7 -> S0 on 0
                        else
                            next_state_comb[7] = 1'b1; // S7 -> S7 on 1
                    end
                    8: begin // S8
                        if (in == 1'b0)
                            next_state_comb[0] = 1'b1; // S8 -> S0 on 0
                        else
                            next_state_comb[1] = 1'b1; // S8 -> S1 on 1
                    end
                    9: begin // S9
                        if (in == 1'b0)
                            next_state_comb[0] = 1'b1; // S9 -> S0 on 0
                        else
                            next_state_comb[1] = 1'b1; // S9 -> S1 on 1
                    end
                endcase

                // Outputs active on S7(0,1), S8(1,0), S9(1,1)
                if (i == 7)
                    out2_comb = 1'b1; // out2=1, out1=0
                else if (i == 8) begin
                    out1_comb = 1'b1; // out1=1, out2=0
                end else if (i == 9) begin
                    out1_comb = 1'b1;
                    out2_comb = 1'b1; // out1=1, out2=1
                end
            end
        end

        next_state = next_state_comb;
        out1 = out1_comb;
        out2 = out2_comb;
    end

endmodule