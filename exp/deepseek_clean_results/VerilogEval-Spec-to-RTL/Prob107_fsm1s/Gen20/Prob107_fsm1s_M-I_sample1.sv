module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Modified state encoding for better timing
    parameter STATE_B = 1'b1;  // Now encoded as 1
    parameter STATE_A = 1'b0;  // Now encoded as 0

    reg state;  // Current state (1-bit encoding)
    wire next_state;  // Next state calculation

    // Optimized transition logic without inversion
    assign next_state = (state & in) | (~state & ~in);  // Equivalent to state xnor in

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Reset to state B
        end else begin
            state <= next_state;  // Normal state transition
        end
    end

    // Output logic - now simply equals state (since B=1)
    assign out = state;  // out=1 in B, out=0 in A

endmodule