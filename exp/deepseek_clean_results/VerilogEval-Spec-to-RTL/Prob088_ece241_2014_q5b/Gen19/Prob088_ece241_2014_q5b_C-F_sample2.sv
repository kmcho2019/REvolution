module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state registers
    reg state_A, state_B;

    // Optimized next state logic
    wire next_state_A = ~x & state_A;
    wire next_state_B = state_B | (state_A & x);  // Sticky implementation

    // Efficient output logic
    assign z = state_A ? x : ~x;

    // State register updates with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

endmodule