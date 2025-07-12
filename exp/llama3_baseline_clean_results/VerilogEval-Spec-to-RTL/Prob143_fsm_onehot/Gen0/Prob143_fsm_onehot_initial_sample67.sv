module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to zero
    assign next_state = 10'b0;

    // Initialize outputs to zero
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // Use a case statement to determine the next state
    always @(*) begin
        case ({state[9], state[8], state[7], state[6], state[5], state[4], state[3], state[2], state[1], state[0]})
            // S0
            10'b0000000001: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[1] = 1'b1;
                end
            end
            // S1
            10'b0000000010: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[2] = 1'b1;
                end
            end
            // S2
            10'b0000000100: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[3] = 1'b1;
                end
            end
            // S3
            10'b0000001000: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[4] = 1'b1;
                end
            end
            // S4
            10'b0000010000: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[5] = 1'b1;
                end
            end
            // S5
            10'b0000100000: begin
                if (!in) begin
                    next_state[8] = 1'b1;
                end else begin
                    next_state[6] = 1'b1;
                end
            end
            // S6
            10'b0001000000: begin
                if (!in) begin
                    next_state[9] = 1'b1;
                end else begin
                    next_state[7] = 1'b1;
                end
            end
            // S7
            10'b0010000000: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[7] = 1'b1;
                end
                out1 = 1'b0;
                out2 = 1'b1;
            end
            // S8
            10'b0100000000: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[1] = 1'b1;
                end
                out1 = 1'b1;
                out2 = 1'b0;
            end
            // S9
            10'b1000000000: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[1] = 1'b1;
                end
                out1 = 1'b1;
                out2 = 1'b1;
            end
            // Handle cases where multiple states are set
            default: begin
                // For each state that is set, determine the next state and output
                if (state[0]) begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[1] = 1'b1;
                    end
                end
                if (state[1]) begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[2] = 1'b1;
                    end
                end
                if (state[2]) begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[3] = 1'b1;
                    end
                end
                if (state[3]) begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[4] = 1'b1;
                    end
                end
                if (state[4]) begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[5] = 1'b1;
                    end
                end
                if (state[5]) begin
                    if (!in) begin
                        next_state[8] = 1'b1;
                    end else begin
                        next_state[6] = 1'b1;
                    end
                end
                if (state[6]) begin
                    if (!in) begin
                        next_state[9] = 1'b1;
                    end else begin
                        next_state[7] = 1'b1;
                    end
                end
                if (state[7]) begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[7] = 1'b1;
                    end
                    out1 = 1'b0;
                    out2 = 1'b1;
                end
                if (state[8]) begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[1] = 1'b1;
                    end
                    out1 = 1'b1;
                    out2 = 1'b0;
                end
                if (state[9]) begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[1] = 1'b1;
                    end
                    out1 = 1'b1;
                    out2 = 1'b1;
                end
            end
        endcase
    end

endmodule