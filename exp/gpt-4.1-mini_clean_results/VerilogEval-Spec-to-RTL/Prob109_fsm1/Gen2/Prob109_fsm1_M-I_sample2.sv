module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

    // State encoding: A=0, B=1
    reg state, next_state;

    // Next state logic as boolean expression
    // From state diagram:
    // B(1): next_state = in ? B(1) : A(0) => next_state = in & 1 + (~in & 0) = in
    // A(0): next_state = in ? A(0) : B(1) => next_state = (~in) & 1 + in & 0 = ~in
    // General: next_state = state ? in : ~in
    always @(*) begin
        next_state = state ? in : ~in;
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // B state
        else
            state <= next_state;
    end

    // Output registered to reduce glitches and switching
    // Moore output: out = state (B=1, A=0)
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1;  // output of state B
        else
            out <= state;
    end

endmodule