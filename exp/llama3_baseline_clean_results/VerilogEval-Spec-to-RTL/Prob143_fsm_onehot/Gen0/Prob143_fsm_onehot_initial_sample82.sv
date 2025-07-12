module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state and outputs
    assign next_state = 10'b0;
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // State transitions
    always @(*) begin
        // Default next_state and outputs
        next_state = 10'b0;
        out1 = 1'b0;
        out2 = 1'b0;

        // S0 transitions
        if (state[0]) begin
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
        end

        // S1 transitions
        if (state[1]) begin
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[2] = 1'b1;
            end
        end

        // S2 transitions
        if (state[2]) begin
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[3] = 1'b1;
            end
        end

        // S3 transitions
        if (state[3]) begin
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[4] = 1'b1;
            end
        end

        // S4 transitions
        if (state[4]) begin
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[5] = 1'b1;
            end
        end

        // S5 transitions
        if (state[5]) begin
            if (!in) begin
                next_state[8] = 1'b1;
            end else begin
                next_state[6] = 1'b1;
            end
        end

        // S6 transitions
        if (state[6]) begin
            if (!in) begin
                next_state[9] = 1'b1;
            end else begin
                next_state[7] = 1'b1;
            end
        end

        // S7 transitions
        if (state[7]) begin
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[7] = 1'b1;
                out1 = 1'b1;
                out2 = 1'b1;
            end
        end

        // S8 transitions
        if (state[8]) begin
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
            out1 = 1'b1;
        end

        // S9 transitions
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

endmodule