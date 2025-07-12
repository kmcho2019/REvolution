module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A, state_B;

    // Simplified next state logic
    wire next_state_A = ~x & state_A;
    wire next_state_B = x | state_B;

    // Optimized output logic - z is x in state_A, ~x otherwise
    assign z = state_A ? x : ~x;

    // Sequential logic with async reset
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