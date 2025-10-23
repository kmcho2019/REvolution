module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [4:0] shift_reg; // 5-bit shift register

// Shift register logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        shift_reg <= 5'b00000; // Reset shift register
    end else begin
        shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
    end
end

// Simplified combinational logic for MATCH signal
assign MATCH = (shift_reg[4] == 1 && shift_reg[3] == 0 && shift_reg[2] == 0 && shift_reg[1] == 1 && shift_reg[0] == 1) ? 1'b1 : 1'b0;

endmodule