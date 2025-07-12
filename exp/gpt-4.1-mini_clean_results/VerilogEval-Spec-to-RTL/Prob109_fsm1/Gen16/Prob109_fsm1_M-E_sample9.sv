module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state_A, state_B;

    // Next state signals
    wire next_A, next_B;

    // One-hot next state logic based on current states and input
    assign next_A = (state_B & ~in) | (state_A & in);
    assign next_B = (state_B & in)  | (state_A & ~in);

    // State registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b0;
            state_B <= 1'b1; // reset to state B
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

    // Output is 1 when in state B, 0 in state A
    assign out = state_B;

endmodule