module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state_A, state_B;

    // Optimized next state logic
    wire next_state_A = state_A & ~x;
    wire next_state_B = ~next_state_A;  // One-hot property

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
            z <= 1'b0;
        end
        else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
            // Registered output for timing improvement
            z <= state_A ? x : ~x;
        end
    end

endmodule