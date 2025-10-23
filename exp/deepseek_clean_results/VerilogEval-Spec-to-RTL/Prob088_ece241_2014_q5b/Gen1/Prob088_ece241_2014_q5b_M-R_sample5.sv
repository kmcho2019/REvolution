module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state register (state_B), state_A is ~state_B
    reg state_B;

    // Next state logic - simpler implementation
    wire next_state_B = state_B | (~state_B & x);

    // Output logic - optimized version
    assign z = (~state_B & x) | (state_B & ~x);

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A (state_B=0)
        end
        else begin
            state_B <= next_state_B;
        end
    end

endmodule