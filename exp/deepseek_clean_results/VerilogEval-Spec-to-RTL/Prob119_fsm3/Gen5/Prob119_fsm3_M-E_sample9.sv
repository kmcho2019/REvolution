module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    reg state_A, state_B, state_C, state_D;

    // Next state logic
    wire next_A = (state_A & ~in) | (state_C & ~in);
    wire next_B = (state_A & in) | (state_B & in) | (state_D & in);
    wire next_C = (state_B & ~in) | (state_D & ~in);
    wire next_D = (state_C & in);

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
            state_C <= 1'b0;
            state_D <= 1'b0;
        end
        else begin
            state_A <= next_A;
            state_B <= next_B;
            state_C <= next_C;
            state_D <= next_D;
        end
    end

    // Output is directly the D state
    assign out = state_D;

endmodule