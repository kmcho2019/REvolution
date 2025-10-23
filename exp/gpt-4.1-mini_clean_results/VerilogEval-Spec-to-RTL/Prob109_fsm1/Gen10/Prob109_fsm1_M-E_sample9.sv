module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot state encoding
    // state_a = 1 means state A
    // state_b = 1 means state B
    reg state_a, state_b;

    // Next state logic signals
    wire next_a, next_b;

    // Combinational next state logic based on current states and input
    assign next_b = (state_b & in) | (state_a & ~in);
    assign next_a = (state_b & ~in) | (state_a & in);

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_a <= 1'b0;  // Reset into state B
            state_b <= 1'b1;
        end else begin
            state_a <= next_a;
            state_b <= next_b;
        end
    end

    // Output is 1 when in state B, 0 otherwise
    assign out = state_b;

endmodule