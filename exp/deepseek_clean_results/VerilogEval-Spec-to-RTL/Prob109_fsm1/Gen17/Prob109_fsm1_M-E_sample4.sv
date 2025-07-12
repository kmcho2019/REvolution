module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // 2-bit shift register implementation
    reg [1:0] state_reg;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= 2'b11; // Initialize to state B
        end else begin
            // Shift in next state bit
            state_reg <= {state_reg[0], 
                         state_reg[1] ? (in ? 1'b1 : 1'b0) :  // From B
                         (in ? 1'b0 : 1'b1)};                // From A
        end
    end
    
    // Output is MSB of register (1 for B, 0 for A)
    assign out = state_reg[1];
    
endmodule