module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding using individual state registers
    reg A, B, C, D, E, F;
    reg next_A, next_B, next_C, next_D, next_E, next_F;

    // Next state logic combinational
    always @* begin
        // Default next state is 0 for all
        next_A = 1'b0;
        next_B = 1'b0;
        next_C = 1'b0;
        next_D = 1'b0;
        next_E = 1'b0;
        next_F = 1'b0;

        if (A) begin
            if (w == 1'b0)
                next_B = 1'b1;
            else
                next_A = 1'b1;
        end else if (B) begin
            if (w == 1'b0)
                next_C = 1'b1;
            else
                next_D = 1'b1;
        end else if (C) begin
            if (w == 1'b0)
                next_E = 1'b1;
            else
                next_D = 1'b1;
        end else if (D) begin
            if (w == 1'b0)
                next_F = 1'b1;
            else
                next_A = 1'b1;
        end else if (E) begin
            if (w == 1'b0)
                next_E = 1'b1;
            else
                next_D = 1'b1;
        end else if (F) begin
            if (w == 1'b0)
                next_C = 1'b1;
            else
                next_D = 1'b1;
        end else begin
            // Default state if none active (should not happen)
            next_A = 1'b1;
        end
    end

    // State registers update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            A <= 1'b1;
            B <= 1'b0;
            C <= 1'b0;
            D <= 1'b0;
            E <= 1'b0;
            F <= 1'b0;
        end else begin
            A <= next_A;
            B <= next_B;
            C <= next_C;
            D <= next_D;
            E <= next_E;
            F <= next_F;
        end
    end

    // Output logic: z = 1 when in E or F states
    always @* begin
        z = E | F;
    end

endmodule