module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state;       // Current state: 0 = A, 1 = B
    wire next_state; // Next state combinational logic

    // Next state logic combinationally derived from current state and input
    assign next_state = (state && in) || (~state && ~in);
    // Explanation:
    // From the original transitions:
    // B(1): in=0 -> A(0), in=1 -> B(1) => next_state = in & state + ~in & ~state
    // A(0): in=0 -> B(1), in=1 -> A(0)
    // This Boolean expression matches the FSM transition

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // Reset asynchronously to B
        else
            state <= next_state;
    end

    assign out = state;

endmodule