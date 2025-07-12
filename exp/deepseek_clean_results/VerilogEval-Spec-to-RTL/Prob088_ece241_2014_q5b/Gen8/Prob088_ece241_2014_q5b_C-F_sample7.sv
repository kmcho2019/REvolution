module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A, state_B;

    // Optimized next state logic
    wire next_state_A = ~x & state_A;
    wire next_state_B = (state_A & x);  // State_B is sticky once set

    // Efficient output logic
    assign z = state_A ? x : ~x;

    // Sequential logic with async reset and sticky state_B
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            state_A <= next_state_A;
            state_B <= state_B | next_state_B;  // Maintain sticky behavior
        end
    end

endmodule