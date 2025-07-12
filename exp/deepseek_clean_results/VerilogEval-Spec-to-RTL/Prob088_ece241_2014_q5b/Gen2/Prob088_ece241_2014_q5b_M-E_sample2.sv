module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state register (state_B)
    reg state_B;

    // Next state logic - enter state_B when x=1 in state_A
    wire next_state_B = (~state_B & x) | state_B;

    // Output is XOR of state and input
    assign z = state_B ^ x;

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state_A
        end
        else begin
            state_B <= next_state_B;
        end
    end

endmodule