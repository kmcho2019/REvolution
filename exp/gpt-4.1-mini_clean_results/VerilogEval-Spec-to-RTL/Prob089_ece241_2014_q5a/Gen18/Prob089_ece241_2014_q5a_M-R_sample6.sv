module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // One-hot state encoding
    reg state0, state1; // state0 = S0, state1 = S1

    // Next state logic
    wire next_state0 = ~state1 & ~(state0 & x);
    wire next_state1 = state1 | (state0 & x);

    // State registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state0 <= 1'b1; // Start in S0
            state1 <= 1'b0;
        end else begin
            state0 <= next_state0;
            state1 <= next_state1;
        end
    end

    // Output logic (Moore output depends only on current state and input x)
    // z = x when in state0 (copy bits)
    // z = ~x when in state1 (invert bits)
    assign z = (state0) ? x : ~x;

endmodule