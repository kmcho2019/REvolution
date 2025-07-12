module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Shift register implementation of states
    reg state_A, state_B;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
            state_B <= 1'b0;
        end else begin
            // Shift left when x=1, hold when x=0
            state_A <= x ? 1'b0 : state_A;
            state_B <= x ? state_A : state_B;
        end
    end

    // Output logic - z is 1 when:
    // 1. In state A and x=1, or
    // 2. In state B and x=0
    assign z = (state_A & x) | (state_B & ~x);

endmodule