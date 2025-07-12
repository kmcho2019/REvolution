module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot state encoding
    reg state_A;
    reg state_B;

    wire next_A;
    wire next_B;

    // Next state logic
    // From state B:
    //   in=0 -> A
    //   in=1 -> B
    // From state A:
    //   in=0 -> B
    //   in=1 -> A

    assign next_A = (state_B & ~in) | (state_A & in);
    assign next_B = (state_B & in)  | (state_A & ~in);

    // State registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b0;
            state_B <= 1'b1;  // Reset to state B
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

    // Output is Moore: output = 1 for state B, 0 for state A
    assign out = state_B;

endmodule