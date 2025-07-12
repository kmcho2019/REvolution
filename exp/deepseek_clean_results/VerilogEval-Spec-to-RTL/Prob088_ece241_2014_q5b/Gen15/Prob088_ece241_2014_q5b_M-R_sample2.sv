module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding
    reg state_A, state_B;
    
    // Next state wires
    wire next_A, next_B;
    
    // State transition logic
    assign next_A = (state_A & ~x) | (state_B & x);
    assign next_B = (state_A & x) | (state_B & ~x) | (state_B & x);
    
    // Output logic
    assign z = (state_A & x) | (state_B & ~x);
    
    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A (one-hot)
            state_B <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

endmodule