module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // 2-bit shift register for state representation
    reg [1:0] state_reg;
    
    // Next state logic (shift operation)
    wire next_bit = (state_reg[1] ? in : ~in);
    
    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state_reg <= 2'b11;  // Initialize to state B
        else
            state_reg <= {state_reg[0], next_bit};
    end
    
    // Output is MSB of shift register (1 for B, 0 for A)
    assign out = state_reg[1];
    
endmodule