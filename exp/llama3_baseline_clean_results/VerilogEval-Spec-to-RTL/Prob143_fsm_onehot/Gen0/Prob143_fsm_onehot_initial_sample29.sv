module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to zero
    assign next_state = 10'b0;

    // Output logic
    assign out1 = (state[9] && in) || (state[8] && in) || (state[7] && in);
    assign out2 = (state[9] && in) || (state[8] && ~in) || (state[7] && ~in);

    // State transition logic
    always @(*) begin
        // Reset all next states
        next_state = 10'b0;

        // State S0
        if (state[0]) begin
            if (~in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
        end

        // State S1
        if (state[1]) begin
            if (~in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[2] = 1'b1;
            end
        end

        // State S2
        if (state[2]) begin
            if (~in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[3] = 1'b1;
            end
        end

        // State S3
        if (state[3]) begin
            if (~in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[4] = 1'b1;
            end
        end

        // State S4
        if (state[4]) begin
            if (~in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[5] = 1'b1;
            end
        end

        // State S5
        if (state[5]) begin
            if (~in) begin
                next_state[8] = 1'b1;
            end else begin
                next_state[6] = 1'b1;
            end
        end

        // State S6
        if (state[6]) begin
            if (~in) begin
                next_state[9] = 1'b1;
            end else begin
                next_state[7] = 1'b1;
            end
        end

        // State S7
        if (state[7]) begin
            if (~in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[7] = 1'b1;
            end
        end

        // State S8
        if (state[8]) begin
            if (~in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
        end

        // State S9
        if (state[9]) begin
            if (~in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
        end
    end
endmodule