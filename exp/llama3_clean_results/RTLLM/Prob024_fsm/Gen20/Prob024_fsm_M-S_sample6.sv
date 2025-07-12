module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [4:0] shift_reg = 5'b00000;

always @(posedge CLK or posedge RST)
    if (RST) shift_reg <= 5'b00000;
    else shift_reg <= {IN, shift_reg[4:1]};

assign MATCH = (shift_reg == 5'b10011);

endmodule