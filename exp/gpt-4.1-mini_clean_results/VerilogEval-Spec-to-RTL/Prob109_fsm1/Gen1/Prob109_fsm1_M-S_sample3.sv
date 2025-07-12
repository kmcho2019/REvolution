module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

    // State encoding: B=1, A=0
    reg state, next_state;

    // Next state logic as boolean expression
    // From FSM:
    // If state=B(1): next_state = in ? B(1) : A(0) => next_state = in & 1 + ~in & 0 = in
    // But careful: B(1) and in=1 -> stay in B(1)
    // So next_state = state ? in : ~in;

    always @(*) begin
        next_state = state ? in : ~in;
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // B
        else
            state <= next_state;
    end

    // Output depends only on state (Moore)
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1; // output for B state
        else
            out <= state;
    end

endmodule