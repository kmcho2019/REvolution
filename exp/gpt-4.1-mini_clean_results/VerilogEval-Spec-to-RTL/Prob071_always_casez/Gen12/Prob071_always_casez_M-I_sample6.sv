module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    casex (in)
        8'bxxxx_xxx1: pos = 3'd0; // bit 0 set
        8'bxxxx_xx1x: pos = 3'd1; // bit 1 set
        8'bxxxx_x1xx: pos = 3'd2; // bit 2 set
        8'bxxxx_1xxx: pos = 3'd3; // bit 3 set
        8'bxxx1_xxxx: pos = 3'd4; // bit 4 set
        8'bxx1x_xxxx: pos = 3'd5; // bit 5 set
        8'bx1xx_xxxx: pos = 3'd6; // bit 6 set
        8'b1xxx_xxxx: pos = 3'd7; // bit 7 set
        default:      pos = 3'd0; // no bits set
    endcase
end

endmodule