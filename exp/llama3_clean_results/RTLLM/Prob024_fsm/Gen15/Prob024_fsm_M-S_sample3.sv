module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [4:0] shift_reg; // 5-bit shift register

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b00000;
        MATCH <= 1'b0;
    end else begin
        shift_reg <= {IN, shift_reg[4:1]};
        MATCH <= (shift_reg == 5'b10011);
    end
end

endmodule