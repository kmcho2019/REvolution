module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding: state[0] = A, state[1] = B
    reg [1:0] state;

    // Next state logic
    wire [1:0] next_state;
    assign next_state[0] = ~x & state[0];  // A -> A when x=0
    assign next_state[1] = (state[0] & x) | state[1];  // A -> B when x=1, or stay in B

    // Output logic (Mealy)
    assign z = state[0] ? x : ~x;  // z=x in A, z=~x in B

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;  // Reset to state A (one-hot)
        else
            state <= next_state;
    end

endmodule