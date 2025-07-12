module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A, state_B;

    // Output logic remains the same (optimal)
    assign z = state_A ? x : ~x;

    // Simplified state transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end
        else begin
            state_A <= ~x & state_A;
            state_B <= (state_A & x) | (state_B & ~x);
        end
    end

endmodule