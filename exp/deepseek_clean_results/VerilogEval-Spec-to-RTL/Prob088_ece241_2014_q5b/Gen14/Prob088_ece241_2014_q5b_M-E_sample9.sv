module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding: A = 01, B = 10
    reg state_A, state_B;

    // Output logic (Mealy)
    assign z = (state_A & x) | (state_B & ~x);

    // Next state logic (parallel computation)
    wire next_A = ~areset & (state_A & ~x);
    wire next_B = ~areset & ((state_A & x) | state_B);

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

endmodule