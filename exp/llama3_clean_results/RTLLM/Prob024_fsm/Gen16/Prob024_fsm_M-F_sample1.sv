module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [4:0] shift_reg; // 5-bit shift register

// Simple and efficient reset logic
always @(posedge RST or posedge CLK) begin
    if (RST) begin
        // Reset shift register and MATCH signal
        shift_reg <= 5'b00000;
        MATCH <= 1'b0;
    end else begin
        // Shift input sequence
        shift_reg <= {IN, shift_reg[4:1]};
        
        // Update MATCH signal based on the shift register content
        MATCH <= (shift_reg == 5'b10011)? 1'b1 : 1'b0;
    end
end

endmodule