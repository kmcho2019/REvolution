module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_B;

    // Simplified next state logic - state_B becomes 1 when x=1 in state_A and stays 1
    wire next_state_B = state_B | (~state_B & x);

    // Output logic remains optimal (z = x when in state_A, ~x when in state_B)
    assign z = state_B ? ~x : x;

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state_B <= 1'b0;  // Reset to state A (state_B = 0)
        else
            state_B <= next_state_B;
    end

endmodule