module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_B;
    reg prev_x;  // Track previous x value for enable condition

    // Next state is simply x when in A, otherwise maintain state
    wire next_state_B = state_B ? 1'b1 : x;

    // Output depends on current state and input
    assign z = state_B ? ~x : x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A (state_B=0)
            prev_x <= 1'b0;
        end
        else if (x != prev_x) begin  // Only update when x changes
            state_B <= next_state_B;
            prev_x <= x;
        end
    end

endmodule