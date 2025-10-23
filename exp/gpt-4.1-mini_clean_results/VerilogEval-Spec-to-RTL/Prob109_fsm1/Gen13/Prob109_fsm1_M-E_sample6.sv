module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot state encoding: state_a and state_b
    reg state_a, state_b;

    // Next state signals
    wire next_a, next_b;

    // Next-state logic according to FSM transitions
    // From B(1): if in=0 next state A, else remain B
    assign next_a = (state_b & ~in) | (state_a & in);
    // From A(0): if in=0 next state B, else remain A
    assign next_b = (state_b & in) | (state_a & ~in);

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_a <= 1'b0;
            state_b <= 1'b1; // reset to B
        end else begin
            state_a <= next_a;
            state_b <= next_b;
        end
    end

    // Moore output depends only on state B
    assign out = state_b;

endmodule