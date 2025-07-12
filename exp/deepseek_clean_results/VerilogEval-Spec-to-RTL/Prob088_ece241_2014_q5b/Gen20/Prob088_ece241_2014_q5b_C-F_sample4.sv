module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A, state_B;

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end
        else begin
            state_A <= ~x & state_A;      // Stay in A only if x=0
            state_B <= (state_A & x) | state_B;  // Enter B on x=1, then stay
        end
    end

    // Efficient combinational output logic
    assign z = state_A ? x : ~x;

endmodule