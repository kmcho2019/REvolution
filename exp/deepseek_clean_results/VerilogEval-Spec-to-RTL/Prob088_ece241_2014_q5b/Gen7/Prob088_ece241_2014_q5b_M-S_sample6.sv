module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_B;  // 1 when in state B, 0 when in state A

    // Next state logic: stay in B or transition from A when x=1
    wire next_state_B = state_B | (~state_B & x);

    // Output logic: z = x in A, ~x in B (equivalent to x XOR state_B)
    assign z = x ^ state_B;

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A
        end
        else begin
            state_B <= next_state_B;
        end
    end

endmodule