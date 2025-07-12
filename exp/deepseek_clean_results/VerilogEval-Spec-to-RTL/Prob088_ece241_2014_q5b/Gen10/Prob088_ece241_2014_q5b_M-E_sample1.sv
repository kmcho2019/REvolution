module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Toggle flip-flop representing state (1=A, 0=B)
    reg state_toggle;

    // Output is XOR of state and input (matches Mealy requirements)
    assign z = state_toggle ^ x;

    // Toggle logic: only toggle when x=1 and in state A (state_toggle=1)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_toggle <= 1'b1;  // Reset to state A
        end else begin
            state_toggle <= state_toggle ^ (state_toggle & x);
        end
    end

endmodule