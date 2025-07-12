module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding
    reg A, B, C, D;
    reg next_A, next_B, next_C, next_D;

    // Next state logic (combinational)
    always @(*) begin
        next_A = 0;
        next_B = 0;
        next_C = 0;
        next_D = 0;

        if (A) begin
            next_A = ~in;
            next_B = in;
        end else if (B) begin
            next_C = ~in;
            next_B = in;
        end else if (C) begin
            next_A = ~in;
            next_D = in;
        end else if (D) begin
            next_C = ~in;
            next_B = in;
        end else begin
            // Default to reset state if none active
            next_A = 1'b1;
        end
    end

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            A <= 1'b1;
            B <= 1'b0;
            C <= 1'b0;
            D <= 1'b0;
        end else begin
            A <= next_A;
            B <= next_B;
            C <= next_C;
            D <= next_D;
        end
    end

    // Output logic (Moore): output=1 only in state D
    assign out = D;

endmodule