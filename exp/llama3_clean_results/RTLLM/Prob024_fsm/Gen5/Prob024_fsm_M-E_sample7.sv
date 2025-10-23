module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

logic [4:0] shift_reg;  // 5-bit shift register to store recent input bits

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b0;  // Reset the shift register
    end else begin
        shift_reg <= {shift_reg[3:0], IN};  // Shift in the new input bit
    end
end

assign MATCH = (shift_reg == 5'b10011);  // Check if the stored sequence matches the target sequence

endmodule