module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Clear state encoding with parameters
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    reg state;  // Current state (1-bit encoding)
    wire next_state;  // Next state calculation

    // Compact transition logic with clear expression
    assign next_state = state ? in : ~in;  // B->A when in=0, A->B when in=0

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Reset to state B
        end else begin
            state <= next_state;  // Normal state transition
        end
    end

    // Output logic - explicit comparison for clarity
    assign out = (state == STATE_B);  // out=1 in B, out=0 in A

endmodule