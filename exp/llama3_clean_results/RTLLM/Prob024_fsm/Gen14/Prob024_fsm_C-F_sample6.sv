module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [4:0] shift_reg; // 5-bit shift register

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b00000; // Reset shift register
        MATCH <= 1'b0; // Reset MATCH signal
    end else begin
        shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
        case (shift_reg)
            5'b10011: MATCH <= 1'b1; // Set MATCH signal to 1 when sequence matches
            default: MATCH <= 1'b0; // Set MATCH signal to 0 otherwise
        endcase
    end
end

endmodule