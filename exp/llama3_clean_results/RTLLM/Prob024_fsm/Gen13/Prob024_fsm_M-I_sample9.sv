module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [3:0] shift_reg; // 4-bit shift register
reg current_bit; // Current input bit

// Shift register logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        shift_reg <= 4'b0000; // Reset shift register
        current_bit <= 1'b0; // Reset current input bit
    end else begin
        shift_reg <= {IN, shift_reg[3:1]}; // Shift input sequence
        current_bit <= IN; // Store current input bit
    end
end

// Combinational logic for MATCH signal
assign MATCH = (shift_reg == 4'b0011 && current_bit == 1'b1)? 1'b1 : 1'b0;

endmodule