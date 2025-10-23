module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State wire (no register needed as we'll use clocked assignment)
    wire state;
    reg state_reg;

    // State transition with synchronous reset
    always @(posedge clk) begin
        state_reg <= reset ? 1'b0 : (state_reg ? in : ~in);
    end

    // Continuous assignment for state
    assign state = state_reg;

    // Output logic remains the same
    assign out = ~state;  // Output 1 in state B (0), 0 in state A (1)

endmodule