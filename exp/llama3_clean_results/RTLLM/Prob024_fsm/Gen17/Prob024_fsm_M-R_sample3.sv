module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [3:0] shift_reg; // 4-bit shift register

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 4'b0000; // Reset shift register
        MATCH <= 1'b0; // Reset MATCH signal
    end else begin
        shift_reg <= {IN, shift_reg[3:1]}; // Shift input sequence
        MATCH <= (shift_reg == 4'b1001) ? 1'b1 : 1'b0; // Set MATCH signal based on shift register
    end
end

endmodule