module TopModule (
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to 0
    assign next_state = 10'b0;

    // State transition logic
    always @(state, in) begin
        // S0
        if (state[0] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
        end

        // S1
        if (state[1] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[2] = 1'b1;
            end
        end

        // S2
        if (state[2] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[3] = 1'b1;
            end
        end

        // S3
        if (state[3] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[4] = 1'b1;
            end
        end

        // S4
        if (state[4] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[5] = 1'b1;
            end
        end

        // S5
        if (state[5] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[8] = 1'b1;
            end else begin
                next_state[6] = 1'b1;
            end
        end

        // S6
        if (state[6] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[9] = 1'b1;
            end else begin
                next_state[7] = 1'b1;
            end
        end

        // S7
        if (state[7] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[7] = 1'b1;
            end
        end

        // S8
        if (state[8] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
        end

        // S9
        if (state[9] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
        end
    end

    // Output logic
    always @(state) begin
        if (state[7] == 1'b1) begin
            out1 = 1'b0;
            out2 = 1'b1;
        end else if (state[8] == 1'b1) begin
            out1 = 1'b1;
            out2 = 1'b0;
        end else if (state[9] == 1'b1) begin
            out1 = 1'b1;
            out2 = 1'b1;
        end else begin
            out1 = 1'b0;
            out2 = 1'b0;
        end
    end

endmodule