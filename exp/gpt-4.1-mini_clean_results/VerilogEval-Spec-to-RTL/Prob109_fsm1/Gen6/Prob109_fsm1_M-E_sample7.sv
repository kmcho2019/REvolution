module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // One-hot state encoding
    // State A: state_A=1, state_B=0
    // State B: state_A=0, state_B=1
    reg state_A, state_B;

    // Next state signals
    wire next_state_A, next_state_B;

    // Next state logic according to the FSM diagram:
    // From B (state_B=1)
    //   If in=0 -> A
    //   If in=1 -> B
    // From A (state_A=1)
    //   If in=0 -> B
    //   If in=1 -> A

    assign next_state_A = (state_B & ~in) | (state_A & in);
    assign next_state_B = (state_B & in) | (state_A & ~in);

    // Sequential logic with asynchronous reset, setting machine to state B
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b0;
            state_B <= 1'b1;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

    // Output depends only on state (Moore machine)
    // Output = 1 for state B, 0 for state A
    assign out = state_B;

endmodule