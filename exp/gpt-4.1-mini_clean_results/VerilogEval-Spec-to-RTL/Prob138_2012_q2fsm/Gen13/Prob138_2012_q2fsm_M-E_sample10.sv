module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot state encoding
    reg A, B, C, D, E, F;
    reg next_A, next_B, next_C, next_D, next_E, next_F;

    // Sequential logic with synchronous active-high reset
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

    // Combinational next-state logic
    always @(*) begin
        // Default to zero
        next_A = 1'b0;
        next_B = 1'b0;
        next_C = 1'b0;
        next_D = 1'b0;
        next_E = 1'b0;
        next_F = 1'b0;

        // Transitions according to FSM
        if (A) begin
            if (w) next_B = 1'b1;
            else   next_A = 1'b1;
        end else if (B) begin
            if (w) next_C = 1'b1;
            else   next_D = 1'b1;
        end else if (C) begin
            if (w) next_E = 1'b1;
            else   next_D = 1'b1;
        end else if (D) begin
            if (w) next_F = 1'b1;
            else   next_A = 1'b1;
        end else if (E) begin
            if (w) next_E = 1'b1;
            else   next_D = 1'b1;
        end else if (F) begin
            if (w) next_C = 1'b1;
            else   next_D = 1'b1;
        end else begin
            // Failsafe: return to state A if no state is active
            next_A = 1'b1;
        end
    end

    // Output logic: z=1 only in states E and F
    assign z = E | F;

endmodule