module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_B;  // 0 = state A, 1 = state B

    // Next state logic - state_B becomes 1 when x=1 in state A and stays 1
    wire next_state_B = state_B | (~state_B & x);

    // Output logic - direct calculation from state and input
    assign z = state_B ? ~x : x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A
        end
        else begin
            state_B <= next_state_B;
        end
    end

endmodule