module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // Single-bit state: 0 = A, 1 = B
    reg state;

    // Next-state logic:
    // From B(1): if in=0 go to A(0), else remain B(1)
    // From A(0): if in=0 go to B(1), else remain A(0)
    wire next_state = (state & in) | (~state & ~in);

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // reset to B
        else
            state <= next_state;
    end

    // Output depends only on state B
    assign out = state;

endmodule