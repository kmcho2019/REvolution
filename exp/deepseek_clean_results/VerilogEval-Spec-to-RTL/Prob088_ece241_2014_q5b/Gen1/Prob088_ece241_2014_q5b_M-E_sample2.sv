module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Binary state encoding: 0=A, 1=B
    reg state;

    // Next state logic - state becomes 1 if either:
    // 1. Already in state B (1), or
    // 2. In state A (0) and x is 1
    wire next_state = state | (~state & x);

    // Output logic - XOR of input and current state
    // Matches required behavior:
    // state A (0): z = x^0 = x (but we need complement, so invert)
    // state B (1): z = x^1 = ~x
    // Wait, actually looking at spec:
    // In state A: x=0→z=0 (x), x=1→z=1 (x)
    // In state B: x=0→z=1 (~x), x=1→z=0 (~x)
    // So z = state ? ~x : x;
    assign z = state ? ~x : x;

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to state A (0)
        end
        else begin
            state <= next_state;
        end
    end

endmodule