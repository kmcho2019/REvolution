module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A, state_B;

    // Next state logic - state_B becomes 1 when x=1 in state A and stays 1
    wire next_state_A = state_A & ~x;
    wire next_state_B = state_B | (state_A & x);

    // Output logic - efficient XOR implementation
    assign z = x ^ state_A;  // Equivalent to state_A ? x : ~x

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end
        else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

endmodule