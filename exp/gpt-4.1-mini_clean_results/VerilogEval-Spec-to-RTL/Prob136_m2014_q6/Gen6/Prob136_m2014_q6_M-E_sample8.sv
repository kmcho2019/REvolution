module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot encoded state bits
    reg state_A, state_B, state_C, state_D, state_E, state_F;
    reg next_A, next_B, next_C, next_D, next_E, next_F;

    // Next state logic (combinational)
    always @(*) begin
        // Default all next states to 0
        next_A = 1'b0;
        next_B = 1'b0;
        next_C = 1'b0;
        next_D = 1'b0;
        next_E = 1'b0;
        next_F = 1'b0;

        // Decode next state based on current state and input w
        if (state_A) begin
            if (w == 1'b0)
                next_B = 1'b1;
            else
                next_A = 1'b1;
        end else if (state_B) begin
            if (w == 1'b0)
                next_C = 1'b1;
            else
                next_D = 1'b1;
        end else if (state_C) begin
            if (w == 1'b0)
                next_E = 1'b1;
            else
                next_D = 1'b1;
        end else if (state_D) begin
            if (w == 1'b0)
                next_F = 1'b1;
            else
                next_A = 1'b1;
        end else if (state_E) begin
            if (w == 1'b0)
                next_E = 1'b1;
            else
                next_D = 1'b1;
        end else if (state_F) begin
            if (w == 1'b0)
                next_C = 1'b1;
            else
                next_D = 1'b1;
        end else begin
            // Default to A if no state is active (safe fallback)
            next_A = 1'b1;
        end
    end

    // State update (sequential logic)
    always @(posedge clk) begin
        if (reset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
            state_C <= 1'b0;
            state_D <= 1'b0;
            state_E <= 1'b0;
            state_F <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
            state_C <= next_C;
            state_D <= next_D;
            state_E <= next_E;
            state_F <= next_F;
        end
    end

    // Output logic: z=1 when in state E or F
    always @(*) begin
        z = state_E | state_F;
    end

endmodule