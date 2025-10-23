module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg [1:0] state;  // one-hot encoding: state[0] = A, state[1] = B
    wire [1:0] next_state;

    // State transition logic
    assign next_state[0] = ~x & state[0];  // Stay in A only if x=0
    assign next_state[1] = (state[0] & x) | state[1];  // Enter B on x=1 or stay in B

    // Output logic (Mealy)
    assign z = (state[0] & x) | (state[1] & ~x);

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;  // Reset to state A
        else
            state <= next_state;
    end

endmodule