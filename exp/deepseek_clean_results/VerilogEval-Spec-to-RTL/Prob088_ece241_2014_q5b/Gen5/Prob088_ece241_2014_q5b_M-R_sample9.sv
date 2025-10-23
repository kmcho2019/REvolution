module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state register (state_A is implicit, state_B is ~state_A)
    reg state_B;

    // Next state logic: state_B persists or gets set when x=1 in state_A
    wire next_state_B = (state_B | (~state_B & x));

    // Output logic: z = x when in state_A, ~x when in state_B
    assign z = x ^ state_B;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A (state_B = 0)
        end
        else begin
            state_B <= next_state_B;
        end
    end

endmodule