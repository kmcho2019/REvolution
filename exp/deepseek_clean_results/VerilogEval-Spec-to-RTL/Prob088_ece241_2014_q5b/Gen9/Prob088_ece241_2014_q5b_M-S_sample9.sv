module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state register (state_A implied, state_B is ~state_A)
    reg state_A;

    // Output is x in state_A, ~x in state_B (Mealy output)
    assign z = state_A ? x : ~x;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
        end else begin
            state_A <= state_A & ~x;  // Stay in A if x=0, else go to B
        end
    end

endmodule