module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    always @(*) begin
        next_state = 10'b0; // Initialize next_state to zero
        out1 = 1'b0; // Initialize out1 to zero
        out2 = 1'b0; // Initialize out2 to zero

        // S0
        if (state[0]) begin
            next_state[!in ? 0 : 1] = 1'b1;
        end

        // S1
        if (state[1]) begin
            next_state[!in ? 0 : 2] = 1'b1;
        end

        // S2
        if (state[2]) begin
            next_state[!in ? 0 : 3] = 1'b1;
        end

        // S3
        if (state[3]) begin
            next_state[!in ? 0 : 4] = 1'b1;
        end

        // S4
        if (state[4]) begin
            next_state[!in ? 0 : 5] = 1'b1;
        end

        // S5
        if (state[5]) begin
            next_state[!in ? 8 : 6] = 1'b1;
        end

        // S6
        if (state[6]) begin
            next_state[!in ? 9 : 7] = 1'b1;
        end

        // S7
        if (state[7]) begin
            next_state[!in ? 0 : 7] = 1'b1;
            out2 = 1'b1;
        end

        // S8
        if (state[8]) begin
            next_state[!in ? 0 : 1] = 1'b1;
            out1 = 1'b1;
        end

        // S9
        if (state[9]) begin
            next_state[!in ? 0 : 1] = 1'b1;
            out1 = 1'b1;
            out2 = 1'b1;
        end

        // Default state
        if (!next_state) begin
            next_state[0] = 1'b1;
        end
    end

endmodule