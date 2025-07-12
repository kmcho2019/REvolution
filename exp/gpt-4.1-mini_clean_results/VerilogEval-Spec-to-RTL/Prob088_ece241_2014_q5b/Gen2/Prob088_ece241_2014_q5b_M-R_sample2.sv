module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // One-hot state bits
    reg state_A, state_B;

    // Next state logic signals
    wire next_state_A, next_state_B;

    // Asynchronous active-high reset and state flip-flops
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

    // Next state logic based on current state and input x
    assign next_state_A = (state_A & ~x);    // Stay in A if in A and x=0
    assign next_state_B = (state_A & x) | (state_B); // Go to or stay in B if appropriate

    // Output logic (Mealy): depends on current state bits and input x
    // From the state table:
    // In A: z = x
    // In B: z = ~x
    assign z = (state_A & x) | (state_B & ~x);

endmodule