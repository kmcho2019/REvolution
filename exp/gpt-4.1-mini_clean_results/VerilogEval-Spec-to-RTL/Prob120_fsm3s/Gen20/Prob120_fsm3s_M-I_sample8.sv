module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding
    reg A, B, C, D;
    reg A_next, B_next, C_next, D_next;

    // Sequential logic with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            A <= 1'b1;
            B <= 1'b0;
            C <= 1'b0;
            D <= 1'b0;
        end else begin
            A <= A_next;
            B <= B_next;
            C <= C_next;
            D <= D_next;
        end
    end

    // Combinational next-state logic (one-hot encoding)
    always @(*) begin
        // Default all next states to 0
        A_next = 1'b0;
        B_next = 1'b0;
        C_next = 1'b0;
        D_next = 1'b0;

        if (A) begin
            if (in == 1'b0) A_next = 1'b1; // Stay in A
            else           B_next = 1'b1; // Go to B
        end else if (B) begin
            if (in == 1'b0) C_next = 1'b1; // Go to C
            else           B_next = 1'b1; // Stay in B
        end else if (C) begin
            if (in == 1'b0) A_next = 1'b1; // Go to A
            else           D_next = 1'b1; // Go to D
        end else if (D) begin
            if (in == 1'b0) C_next = 1'b1; // Go to C
            else           B_next = 1'b1; // Go to B
        end else begin
            // If none active (should never happen), reset to A
            A_next = 1'b1;
        end
    end

    // Moore output: only high in state D
    assign out = D;

endmodule