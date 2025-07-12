module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [4:0] shift_reg; // 5-bit shift register
reg       match_reg; // Register for MATCH signal

// Shift register and MATCH signal logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        shift_reg <= 5'b00000; // Reset shift register
        match_reg <= 1'b0; // Reset MATCH signal
    end else begin
        shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
        match_reg <= (shift_reg == 5'b10011)? 1'b1 : 1'b0; // Update MATCH signal
    end
end

assign MATCH = match_reg; // Output MATCH signal

endmodule