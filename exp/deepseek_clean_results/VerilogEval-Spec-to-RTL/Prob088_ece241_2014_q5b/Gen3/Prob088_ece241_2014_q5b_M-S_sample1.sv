module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_B;  // state_A is implied as ~state_B

    // Next state logic: stay in B if already there, or move from A to B when x=1
    wire next_state_B = state_B | (~state_B & x);

    // Output logic: z = x in state_A, ~x in state_B
    assign z = state_B ? ~x : x;

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state_A (state_B=0)
        end
        else begin
            state_B <= next_state_B;
        end
    end

endmodule