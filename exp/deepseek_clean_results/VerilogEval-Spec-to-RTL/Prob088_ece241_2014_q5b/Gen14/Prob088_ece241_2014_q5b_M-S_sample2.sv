module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state bit: 0=state_A, 1=state_B
    reg state_B;

    // Output logic - z is x when in state A, ~x otherwise
    assign z = state_B ? ~x : x;

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A
        end else begin
            state_B <= state_B | x;  // Move to B on first '1' and stay
        end
    end

endmodule