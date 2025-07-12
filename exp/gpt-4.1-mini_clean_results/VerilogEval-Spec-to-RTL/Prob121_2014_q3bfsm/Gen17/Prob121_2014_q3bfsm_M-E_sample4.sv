module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    // One-hot state registers: S0 to S4 represent states 000 to 100 respectively
    reg S0, S1, S2, S3, S4;
    reg S0_next, S1_next, S2_next, S3_next, S4_next;

    // Synchronous reset and state update
    always @(posedge clk) begin
        if (reset) begin
            S0 <= 1'b1;
            S1 <= 1'b0;
            S2 <= 1'b0;
            S3 <= 1'b0;
            S4 <= 1'b0;
        end else begin
            S0 <= S0_next;
            S1 <= S1_next;
            S2 <= S2_next;
            S3 <= S3_next;
            S4 <= S4_next;
        end
    end

    // Next state logic combinational
    always @(*) begin
        // Default all next states to 0
        S0_next = 1'b0;
        S1_next = 1'b0;
        S2_next = 1'b0;
        S3_next = 1'b0;
        S4_next = 1'b0;

        // Determine next state based on current state and input x
        if (S0) begin
            if (x) S1_next = 1'b1; else S0_next = 1'b1;
        end else if (S1) begin
            if (x) S4_next = 1'b1; else S1_next = 1'b1;
        end else if (S2) begin
            if (x) S1_next = 1'b1; else S2_next = 1'b1;
        end else if (S3) begin
            if (x) S2_next = 1'b1; else S1_next = 1'b1;
        end else if (S4) begin
            if (x) S4_next = 1'b1; else S3_next = 1'b1;
        end else begin
            // Undefined state fallback: reset to S0
            S0_next = 1'b1;
        end
    end

    // Output logic combinational
    always @(*) begin
        z = S3 | S4;
    end

endmodule