module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions (clear naming from Example 1)
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    reg state;  // Current state (1-bit representation)

    // State transition logic (compact from Example 2)
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to state B
        end else begin
            state <= state ? in : ~in;  // Efficient transition logic
        end
    end

    // Output logic (state B=1, A=0)
    assign out = (state == STATE_B);  // Direct comparison for clarity

endmodule