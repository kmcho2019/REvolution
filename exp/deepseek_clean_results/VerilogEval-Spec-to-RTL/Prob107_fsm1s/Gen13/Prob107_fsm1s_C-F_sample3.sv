module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions for clarity
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    reg state;  // Current state (1-bit representation)

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to state B
        end else begin
            // Efficient transition logic:
            // STATE_B: transition on ~in
            // STATE_A: transition on in
            state <= state ? in : ~in;
        end
    end

    // Output is 1 when in state B (Moore machine)
    assign out = (state == STATE_B);

endmodule