module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // 2-bit shift register for state encoding
    // '11' = State B, '00' = State A
    reg [1:0] state_reg;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= 2'b11; // Reset to State B
        end else begin
            // Shift register update logic
            case (state_reg)
                2'b00: state_reg <= in ? 2'b00 : 2'b11; // A->A or A->B
                2'b11: state_reg <= in ? 2'b11 : 2'b00; // B->B or B->A
                default: state_reg <= 2'b11; // Handle invalid states
            endcase
        end
    end
    
    // Output is MSB of state register (1 for B, 0 for A)
    assign out = state_reg[1];
    
endmodule