module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Clear state encoding (from Example 2)
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    reg state;  // 0=B, 1=A (minimal representation from Example 1)

    // Compact transition logic (from Example 1)
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to B
        end else begin
            state <= state ? in : ~in;  // Optimized transition logic
        end
    end

    // Clear output logic (combination of both examples)
    assign out = (state == STATE_B);  // Explicit comparison (Example 2), simple logic (Example 1)

endmodule