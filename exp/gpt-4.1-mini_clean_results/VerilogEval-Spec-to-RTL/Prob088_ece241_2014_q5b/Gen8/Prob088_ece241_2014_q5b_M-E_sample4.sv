module TopModule (
    input        clk,
    input        areset,
    input        x,
    output       z
);
    reg [1:0] state; // state[0] = A, state[1] = B (one-hot)

    // Next state combinational logic
    wire [1:0] next_state;
    assign next_state[0] = (state[0] & ~x);      // Stay in A if x=0 and currently in A
    assign next_state[1] = state[1] | (state[0] & x); // Stay in B or move to B if in A and x=1

    // Output combinational logic (Mealy): 
    // z = x when in A (state[0]=1), else z = ~x when in B (state[1]=1)
    assign z = (state[0] & x) | (state[1] & ~x);

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // Reset to state A
        else
            state <= next_state;
    end
endmodule