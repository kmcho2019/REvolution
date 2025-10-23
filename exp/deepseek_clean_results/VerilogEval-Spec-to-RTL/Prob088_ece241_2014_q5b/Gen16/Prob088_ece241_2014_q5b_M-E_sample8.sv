module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state register (0 = A, 1 = B)
    reg state;

    // Next state logic (combinational)
    wire next_state = areset ? 1'b0 :  // Reset to state A
                     (state ? 1'b1 :   // Stay in B once entered
                     (x ? 1'b1 : 1'b0)); // Transition to B on x=1

    // Output logic (combinational Mealy output)
    // z = x when in state A and x=1 (transition to B)
    //    or when in state B and x=0
    assign z = (state & ~x) | (~state & x);

    // State register update (sequential)
    always @(posedge clk or posedge areset) begin
        state <= next_state;
    end

endmodule