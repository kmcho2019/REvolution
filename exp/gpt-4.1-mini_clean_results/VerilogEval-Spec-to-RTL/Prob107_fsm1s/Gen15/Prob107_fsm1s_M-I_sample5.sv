module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // Next-state logic as direct Boolean expression:
    // From FSM:
    // B(0): next_state = (in==0)? A(1): B(0) -> next_state = (~state & ~in) | (state & in);
    // A(1): next_state = (in==0)? B(0): A(1) -> next_state = (~state & ~in) | (state & in);
    // Actually, from table:
    // B->A if in=0: next_state=1 when state=0 & in=0
    // A->B if in=0: next_state=0 when state=1 & in=0
    // So next_state = state XOR ~in (since transition occurs when in=0)
    // Simplify:
    assign next_state = state ^ (~in);

    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Output is 1 when in state B (state == 0)
    assign out = ~state;

endmodule