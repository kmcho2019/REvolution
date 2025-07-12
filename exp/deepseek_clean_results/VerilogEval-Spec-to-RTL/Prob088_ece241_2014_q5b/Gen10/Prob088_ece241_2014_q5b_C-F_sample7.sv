module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A;  // state_B is implicitly ~state_A

    // Mealy output logic - depends on current state and input
    assign z = state_A ? x : ~x;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
        end else begin
            // Transition to B when x=1 in state A, stay in B otherwise
            state_A <= state_A & ~x;
        end
    end

endmodule