module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_B;  // state_A is implicitly ~state_B

    // Simplified next state logic
    wire next_state_B = (state_B) ? 1'b1 : x;

    // Efficient output logic using XOR
    assign z = x ^ state_B;

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A (state_B=0)
        end
        else begin
            state_B <= next_state_B;
        end
    end

endmodule