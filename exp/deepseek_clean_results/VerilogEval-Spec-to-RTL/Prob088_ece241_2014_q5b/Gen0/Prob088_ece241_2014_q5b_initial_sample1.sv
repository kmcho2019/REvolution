module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding
    reg state_A, state_B;

    // Next state and output logic
    wire next_state_A, next_state_B;
    assign next_state_A = state_A & ~x;
    assign next_state_B = (state_A & x) | (state_B);

    // Output is Mealy-type (depends on current state and input)
    assign z = (state_A & x) | (state_B & ~x);

    // State transition with asynchronous reset
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