module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding: state_B = 1'b1, state_A = 1'b0
    reg state_B, state_A;

    // Next state logic
    wire next_state_B = (state_B & in) | (state_A & ~in);
    wire next_state_A = (state_B & ~in) | (state_A & in);

    // State update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state_B <= 1'b1;
            state_A <= 1'b0;
        end else begin
            state_B <= next_state_B;
            state_A <= next_state_A;
        end
    end

    // Output is state_B
    assign out = state_B;

endmodule