module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

    // State encoding: 1 bit: A=0, B=1
    reg state;

    // Next state logic as a boolean expression:
    // From the diagram:
    // B=1: next = in ? B(1) : A(0) => next = in & 1 | ~in & 0 = in
    // A=0: next = in ? A(0) : B(1) => next = in & 0 | ~in & 1 = ~in
    // So overall:
    // if state=1 (B), next_state = in
    // if state=0 (A), next_state = ~in
    // Expression: next_state = state ? in : ~in;
    wire next_state = state ? in : ~in;

    // Asynchronous reset state register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // reset to B
        else
            state <= next_state;
    end

    // Output logic: Moore machine output depends only on state
    // B=1 => out=1, A=0 => out=0
    // Register output to reduce glitches
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1;
        else
            out <= state;
    end

endmodule