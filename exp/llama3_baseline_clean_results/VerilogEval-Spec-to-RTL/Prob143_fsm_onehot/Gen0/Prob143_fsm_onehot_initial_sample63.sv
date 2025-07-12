module TopModule(
    input  in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to all zeros
    assign next_state = 10'b0000000000;

    // Initialize outputs to zero
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // Check for each state and determine next state and outputs
    always @(state, in) begin
        // Check for S7
        if (state[7]) begin
            next_state[0] = 1'b1;
            out2 = 1'b1;
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[7] = 1'b1;
            end
        // Check for S9
        end else if (state[9]) begin
            next_state[0] = 1'b1;
            out1 = 1'b1;
            out2 = 1'b1;
            if (in) begin
                next_state[1] = 1'b1;
            end
        // Check for S8
        end else if (state[8]) begin
            next_state[0] = 1'b1;
            out1 = 1'b1;
            if (in) begin
                next_state[1] = 1'b1;
            end
        // Check for S5
        end else if (state[5]) begin
            if (in) begin
                next_state[6] = 1'b1;
            end else begin
                next_state[8] = 1'b1;
            end
        // Check for S6
        end else if (state[6]) begin
            if (in) begin
                next_state[7] = 1'b1;
            end else begin
                next_state[9] = 1'b1;
            end
        // Check for S4
        end else if (state[4]) begin
            if (in) begin
                next_state[5] = 1'b1;
            end else begin
                next_state[0] = 1'b1;
            end
        // Check for S3
        end else if (state[3]) begin
            if (in) begin
                next_state[4] = 1'b1;
            end else begin
                next_state[0] = 1'b1;
            end
        // Check for S2
        end else if (state[2]) begin
            if (in) begin
                next_state[3] = 1'b1;
            end else begin
                next_state[0] = 1'b1;
            end
        // Check for S1
        end else if (state[1]) begin
            if (in) begin
                next_state[2] = 1'b1;
            end else begin
                next_state[0] = 1'b1;
            end
        // Check for S0
        end else if (state[0]) begin
            if (in) begin
                next_state[1] = 1'b1;
            end else begin
                next_state[0] = 1'b1;
            end
        end
    end

endmodule