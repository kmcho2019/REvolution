module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding: A=0, B=1
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    wire next_state;

    // Combinational next state logic optimized:
    // If current state is B (1), next state is A if in=0 else B
    // If current state is A (0), next state is B if in=0 else A
    // This can be expressed as: next_state = state ^ (~in);
    // Explanation: 
    //   state B=1: next_state = 1 ^ (~in) = ~in
    //       in=0 => ~in=1 => next_state=1 ^ 1=0 (A)
    //       in=1 => ~in=0 => next_state=1 ^ 0=1 (B)
    //   state A=0: next_state = 0 ^ (~in) = ~in
    //       in=0 => next_state=1 (B)
    //       in=1 => next_state=0 (A)
    // This expression correctly implements the FSM transitions.

    assign next_state = state ^ (~in);

    // State register with asynchronous reset to B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output equals current state
    assign out = state;

endmodule