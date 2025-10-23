module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [4:0] shift_reg; // 5-bit shift register

// Reset logic
always @(posedge RST) begin
    shift_reg <= 5'b00000; // Reset shift register
end

// Shift register logic
always @(posedge CLK) begin
    if(~RST) begin
        shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
    end
end

// Combinational logic for MATCH signal
assign MATCH = (shift_reg == 5'b10011)? 1'b1 : 1'b0;

endmodule