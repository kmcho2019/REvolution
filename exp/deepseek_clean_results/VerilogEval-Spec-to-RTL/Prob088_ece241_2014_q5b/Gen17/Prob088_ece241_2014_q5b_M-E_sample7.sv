module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State flag: 0 = A, 1 = B
    reg state_flag;

    // Next state logic
    wire next_state = state_flag ? 1'b1 : x;

    // Output logic - Mealy: depends on both state and input
    assign z = state_flag ? ~x : x;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state_flag <= 1'b0;  // Reset to state A
        else
            state_flag <= next_state;
    end

endmodule