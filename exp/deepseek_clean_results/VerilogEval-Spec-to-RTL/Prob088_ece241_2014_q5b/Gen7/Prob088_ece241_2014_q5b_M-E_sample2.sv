module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg x_prev;
    reg state_A, state_B;

    // Detect input transitions
    wire x_changed = (x != x_prev);

    // Next state logic (only transition on input changes)
    wire next_state_A = state_A & ~x_changed;
    wire next_state_B = (state_A & x_changed) | (state_B & x_changed);

    // Output depends on previous x value and state
    assign z = state_A ? x_prev : ~x_prev;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
            x_prev <= 1'b0;
        end
        else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
            x_prev <= x;
        end
    end

endmodule