module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to zero
    assign next_state = 10'b0;

    // Initialize out1 and out2 to zero
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // Iterate through each state bit and calculate next state
    always @(*) begin
        for (int i = 0; i < 10; i++) begin
            if (state[i] == 1'b1) begin
                case (i)
                    0: begin // S0
                        if (in == 1'b0) begin
                            next_state[0] = 1'b1;
                        end else begin
                            next_state[1] = 1'b1;
                        end
                    end
                    1: begin // S1
                        if (in == 1'b0) begin
                            next_state[0] = 1'b1;
                        end else begin
                            next_state[2] = 1'b1;
                        end
                    end
                    2: begin // S2
                        if (in == 1'b0) begin
                            next_state[0] = 1'b1;
                        end else begin
                            next_state[3] = 1'b1;
                        end
                    end
                    3: begin // S3
                        if (in == 1'b0) begin
                            next_state[0] = 1'b1;
                        end else begin
                            next_state[4] = 1'b1;
                        end
                    end
                    4: begin // S4
                        if (in == 1'b0) begin
                            next_state[0] = 1'b1;
                        end else begin
                            next_state[5] = 1'b1;
                        end
                    end
                    5: begin // S5
                        if (in == 1'b0) begin
                            next_state[8] = 1'b1;
                        end else begin
                            next_state[6] = 1'b1;
                        end
                    end
                    6: begin // S6
                        if (in == 1'b0) begin
                            next_state[9] = 1'b1;
                        end else begin
                            next_state[7] = 1'b1;
                        end
                    end
                    7: begin // S7
                        if (in == 1'b0) begin
                            next_state[0] = 1'b1;
                            out1 = 1'b0;
                            out2 = 1'b1;
                        end else begin
                            next_state[7] = 1'b1;
                            out1 = 1'b0;
                            out2 = 1'b1;
                        end
                    end
                    8: begin // S8
                        if (in == 1'b0) begin
                            next_state[0] = 1'b1;
                            out1 = 1'b1;
                            out2 = 1'b0;
                        end else begin
                            next_state[1] = 1'b1;
                            out1 = 1'b1;
                            out2 = 1'b0;
                        end
                    end
                    9: begin // S9
                        if (in == 1'b0) begin
                            next_state[0] = 1'b1;
                            out1 = 1'b1;
                            out2 = 1'b1;
                        end else begin
                            next_state[1] = 1'b1;
                            out1 = 1'b1;
                            out2 = 1'b1;
                        end
                    end
                endcase
            end
        end
    end

endmodule