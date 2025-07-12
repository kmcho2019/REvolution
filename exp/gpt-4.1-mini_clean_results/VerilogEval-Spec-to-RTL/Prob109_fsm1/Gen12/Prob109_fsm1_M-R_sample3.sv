module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state;          // Current state: 0 = A, 1 = B
    wire next_state;    // Next state combinational logic

    // Next state logic based on the Moore state diagram
    // B (1) --0--> A(0)
    // B (1) --1--> B(1)
    // A (0) --0--> B(1)
    // A (0) --1--> A(0)
    assign next_state = (state) ?          // if in state B (1)
                        (in ? 1'b1 : 1'b0) :  // stay in B if input=1, else go to A
                        (in ? 1'b0 : 1'b1);   // stay in A if input=1, else go to B

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // Reset to state B
        else
            state <= next_state;
    end

    // Output is the current state (Moore output)
    assign out = state;

endmodule