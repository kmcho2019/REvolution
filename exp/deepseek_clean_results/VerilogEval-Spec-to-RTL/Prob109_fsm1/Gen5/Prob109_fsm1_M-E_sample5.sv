module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Shift register implementation
    reg [1:0] state_reg;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= 2'b11;  // Reset to state B
        end else begin
            // Shift left and insert new bit based on current state and input
            state_reg <= {state_reg[0], 
                         (state_reg == 2'b00) ? in :  // From A: 0->B(1), 1->A(0)
                         (state_reg == 2'b11) ? in :  // From B: 0->A(0), 1->B(1)
                         1'b0};                       // Default (shouldn't occur)
        end
    end
    
    // Output is MSB of the register (1 for B, 0 for A)
    assign out = state_reg[1];
    
endmodule