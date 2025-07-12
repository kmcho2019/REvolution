module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // One-hot state encoding: A,B,C,D,E,F
    reg A, B, C, D, E, F;
    reg nA, nB, nC, nD, nE, nF;

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            A <= 1'b1;   // Reset to state A
            B <= 1'b0;
            C <= 1'b0;
            D <= 1'b0;
            E <= 1'b0;
            F <= 1'b0;
        end else begin
            A <= nA;
            B <= nB;
            C <= nC;
            D <= nD;
            E <= nE;
            F <= nF;
        end
    end

    // Next state logic
    always @(*) begin
        // Default: no states active
        nA = 1'b0; nB = 1'b0; nC = 1'b0; nD = 1'b0; nE = 1'b0; nF = 1'b0;

        if (A) begin
            if (w)
                nB = 1'b1;
            else
                nA = 1'b1;
        end else if (B) begin
            if (w)
                nC = 1'b1;
            else
                nD = 1'b1;
        end else if (C) begin
            if (w)
                nE = 1'b1;
            else
                nD = 1'b1;
        end else if (D) begin
            if (w)
                nF = 1'b1;
            else
                nA = 1'b1;
        end else if (E) begin
            if (w)
                nE = 1'b1;
            else
                nD = 1'b1;
        end else if (F) begin
            if (w)
                nC = 1'b1;
            else
                nD = 1'b1;
        end else begin
            // In case no state active (should not happen), reset to A
            nA = 1'b1;
        end
    end

    // Output logic: z=1 only in state E, otherwise 0
    always @(*) begin
        z = E;
    end

endmodule