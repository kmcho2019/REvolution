module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state bit: 0=state_A, 1=state_B
    reg state_B;

    // Output logic - z is x when in state A, ~x when in state B
    assign z = state_B ? ~x : x;

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A
        end else begin
            // Stay in B or transition from A to B on x=1
            state_B <= state_B | x;
        end
    end

endmodule