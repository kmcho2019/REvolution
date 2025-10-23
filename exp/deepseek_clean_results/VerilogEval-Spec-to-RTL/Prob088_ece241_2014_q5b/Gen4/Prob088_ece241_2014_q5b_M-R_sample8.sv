module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A, state_B;

    // State updates with direct assignment and ternary operators
    assign state_A = areset ? 1'b1 : (state_A & ~x);
    assign state_B = areset ? 1'b0 : (state_B | (state_A & x));

    // Output logic remains the same
    assign z = state_A ? x : ~x;

    // Clocked state updates
    always @(posedge clk) begin
        state_A <= state_A;
        state_B <= state_B;
    end

endmodule