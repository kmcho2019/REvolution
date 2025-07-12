module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);
    // State encoding: [1:0] = {state_B, state_A}
    reg [1:0] state;

    // Next state and output signals
    wire [1:0] next_state;
    wire       z_comb;

    // State bits for readability
    wire state_A = state[0];
    wire state_B = state[1];

    // Next-state logic (one-hot encoded)
    assign next_state[0] = (state_A & ~x);      // next A: stay in A if x=0
    assign next_state[1] = (state_B) | (state_A & x); // next B: stay in B or go to B if x=1 from A

    // Output logic (Mealy): z depends on current state and input x
    // z = x when in state A, z = ~x when in state B
    assign z_comb = (state_A & x) | (state_B & ~x);

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // Reset to state A (one-hot: A=1, B=0)
        else
            state <= next_state;
    end

    assign z = z_comb;

endmodule