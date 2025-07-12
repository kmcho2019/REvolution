module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A, state_B;

    // Next state logic - state_B becomes permanently set once activated
    wire next_state_A = state_A & ~x;
    wire next_state_B = state_A & x;

    // Output logic - static in state B to reduce power
    assign z = state_A ? x : 1'b1;

    // State transition with simplified sticky behavior
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end
        else begin
            state_A <= next_state_A;
            if (next_state_B) state_B <= 1'b1;  // Set once and stay
        end
    end

endmodule