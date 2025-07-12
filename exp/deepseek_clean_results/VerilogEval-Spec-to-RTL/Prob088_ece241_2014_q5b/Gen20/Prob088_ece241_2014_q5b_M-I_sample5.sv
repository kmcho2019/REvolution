module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A, state_B;  // One-hot states

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            state_A <= state_A & ~x;
            state_B <= (state_A & x) | (state_B & ~x);
        end
    end

    // Optimized output logic using XOR
    assign z = state_B ^ x;

endmodule