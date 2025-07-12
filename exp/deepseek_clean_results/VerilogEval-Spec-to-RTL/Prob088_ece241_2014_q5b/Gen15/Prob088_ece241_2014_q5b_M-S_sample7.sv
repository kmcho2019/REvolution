module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A, state_B;

    // Minimal next state logic
    assign state_A = ~areset ? (state_A & ~x) : 1'b1;
    assign state_B = ~areset ? (state_B | (state_A & x)) : 1'b0;

    // Optimal output logic
    assign z = state_A ? x : ~x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end
        else begin
            state_A <= state_A & ~x;
            state_B <= state_B | (state_A & x);
        end
    end

endmodule