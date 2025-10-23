module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to all zeros
    assign next_state = 10'b0;
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // Determine next state and output values based on current state and input
    always @(*) begin
        // S0
        if (state[0]) begin
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
        end

        // S1
        if (state[1]) begin
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[2] = 1'b1;
            end
        end

        // S2
        if (state[2]) begin
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[3] = 1'b1;
            end
        end

        // S3
        if (state[3]) begin
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[4] = 1'b1;
            end
        end

        // S4
        if (state[4]) begin
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[5] = 1'b1;
            end
        end

        // S5
        if (state[5]) begin
            if (!in) begin
                next_state[8] = 1'b1;
            end else begin
                next_state[6] = 1'b1;
            end
        end

        // S6
        if (state[6]) begin
            if (!in) begin
                next_state[9] = 1'b1;
            end else begin
                next_state[7] = 1'b1;
            end
        end

        // S7
        if (state[7]) begin
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[7] = 1'b1;
            end
            out1 = 1'b0;
            out2 = 1'b1;
        end

        // S8
        if (state[8]) begin
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
            out1 = 1'b1;
            out2 = 1'b0;
        end

        // S9
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