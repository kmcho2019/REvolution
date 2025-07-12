module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Simplified combinational next-state logic using boolean expressions:
    // From the state diagram:
    // When in B (state=1), next_state = (~in) ? A(0) : B(1) => next_state = state & in
    // When in A (state=0), next_state = (~in) ? B(1) : A(0) => next_state = (~state) & (~in) ? B : A
    // Simplifying the expression: next_state = (state & in) | (~state & ~in)
    always @(*) begin
        next_state = (state & in) | (~state & ~in);
    end

    // State register with asynchronous reset to state B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output assigned directly from current state (Moore machine)
    assign out = state;

endmodule