module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot state encoding
    reg state_A, state_B, state_C, state_D;
    reg next_A, next_B, next_C, next_D;

    // Next-state combinational logic
    always @(*) begin
        // Default next states to zero
        next_A = 0;
        next_B = 0;
        next_C = 0;
        next_D = 0;

        if (state_A) begin
            if (in)
                next_B = 1;
            else
                next_A = 1;
        end else if (state_B) begin
            if (in)
                next_B = 1;
            else
                next_C = 1;
        end else if (state_C) begin
            if (in)
                next_D = 1;
            else
                next_A = 1;
        end else if (state_D) begin
            if (in)
                next_B = 1;
            else
                next_C = 1;
        end else begin
            // In case of invalid state, reset to A
            next_A = 1;
        end
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1;
            state_B <= 0;
            state_C <= 0;
            state_D <= 0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
            state_C <= next_C;
            state_D <= next_D;
        end
    end

    // Output logic: output=1 when in state D (one-hot)
    assign out = state_D;

endmodule