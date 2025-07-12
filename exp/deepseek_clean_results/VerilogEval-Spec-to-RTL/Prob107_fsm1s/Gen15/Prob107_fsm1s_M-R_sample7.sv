module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    reg state;  // 0 = B, 1 = A

    // Next state logic (combinational)
    wire next_state = state ? in : ~in;

    // State and output update (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= 0;      // Reset to state B (0)
            out <= 1;       // Output for state B
        end else begin
            state <= next_state;
            out <= ~next_state;  // Output is inverse of state (1 for B, 0 for A)
        end
    end

endmodule