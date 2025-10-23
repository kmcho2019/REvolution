module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // One-hot state registers
    reg state_A, state_B;

    // Next state logic (combinational)
    wire next_state_A = state_A & ~x;
    wire next_state_B = (state_A & x) | (state_B);

    // Output logic (combinational Mealy output)
    always @(*) begin
        if (state_A) z = x;
        else         z = ~x;
    end

    // State register updates (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset to state A
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            // Normal state transition
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

endmodule