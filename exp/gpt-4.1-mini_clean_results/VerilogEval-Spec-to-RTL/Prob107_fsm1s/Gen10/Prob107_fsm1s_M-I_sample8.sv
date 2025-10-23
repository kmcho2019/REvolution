module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding and output in single bit:
    // state=1 => A (out=0)
    // state=0 => B (out=1)
    reg state, next_state;

    // Synchronous active-high reset state update
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // B state
        else
            state <= next_state;
    end

    // Combinational next_state logic expressed with boolean logic
    // From transitions:
    // B(0): next_state = (in==0)? A(1) : B(0)  => next_state = ~in & ~state | state & ??? (but since state=0, simplified)
    // A(1): next_state = (in==0)? B(0) : A(1)
    // Simplify:
    // next_state = (state & in) | (~state & ~in);
    // Because:
    // If state=0(B), in=0 => next_state=1 (A)
    // If state=0(B), in=1 => next_state=0 (B)
    // If state=1(A), in=0 => next_state=0 (B)
    // If state=1(A), in=1 => next_state=1 (A)
    assign next_state = (state & in) | (~state & ~in);

    // Output is inverse of state, because out=1 in B (state=0), out=0 in A (state=1)
    assign out = ~state;

endmodule