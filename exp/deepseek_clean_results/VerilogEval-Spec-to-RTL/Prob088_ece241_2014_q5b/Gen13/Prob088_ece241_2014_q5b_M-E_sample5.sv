module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_reg;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= 1'b0;  // Reset to state A
        end
        else begin
            // Transition to B on x=1, stay in B forever
            if (state_reg == 1'b0 && x == 1'b1)
                state_reg <= 1'b1;
            // Otherwise maintain current state
        end
    end

    // Output logic - XOR between state and input
    assign z = state_reg ^ x;

endmodule