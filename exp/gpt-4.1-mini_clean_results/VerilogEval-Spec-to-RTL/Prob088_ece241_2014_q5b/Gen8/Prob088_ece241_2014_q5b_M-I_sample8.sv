module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);
    // One-hot encoded states
    reg state_A, state_B;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1; // Reset to state A
            state_B <= 1'b0;
        end else begin
            // Next state logic
            // state_A = state_A & ~x
            // state_B = state_B | (state_A & x)
            state_A <= state_A & (~x);
            state_B <= state_B | (state_A & x);
        end
    end

    // Mealy output: z = (state_A & x) | (state_B & ~x)
    always @(*) begin
        z = (state_A & x) | (state_B & ~x);
    end
endmodule