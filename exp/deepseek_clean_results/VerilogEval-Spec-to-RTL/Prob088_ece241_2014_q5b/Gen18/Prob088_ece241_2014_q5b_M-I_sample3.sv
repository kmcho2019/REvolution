module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A;

    // Simplified next state logic - only transition when x=1 in state A
    wire next_state_A = ~x & state_A;

    // Output is x in state A, ~x otherwise (direct combinational logic)
    assign z = state_A ? x : ~x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
        end else begin
            state_A <= next_state_A;
        end
    end

endmodule