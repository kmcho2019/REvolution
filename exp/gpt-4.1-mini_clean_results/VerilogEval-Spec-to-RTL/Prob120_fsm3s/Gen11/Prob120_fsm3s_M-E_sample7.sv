module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding
    reg A, B, C, D;
    reg next_A, next_B, next_C, next_D;

    // Combinational logic for next state
    always @(*) begin
        // Defaults: no state active
        next_A = 1'b0;
        next_B = 1'b0;
        next_C = 1'b0;
        next_D = 1'b0;

        // Next state logic based on current state and input
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
            // If no state active (should not happen), reset to A
            next_A = 1'b1;
        end
    end

    // Output logic (Moore): output=1 only in state D
    assign out = D;

    // Sequential logic: state flip-flops with synchronous reset
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

endmodule