module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    casez (in)
        8'b????_???1: pos = 3'd0; // bit 0 set
        8'b????_??10: pos = 3'd1; // bit 1 set
        8'b????_?100: pos = 3'd2; // bit 2 set
        8'b????_1000: pos = 3'd3; // bit 3 set
        8'b???1_0000: pos = 3'd4; // bit 4 set
        8'b??10_0000: pos = 3'd5; // bit 5 set
        8'b?100_0000: pos = 3'd6; // bit 6 set
        8'b1000_0000: pos = 3'd7; // bit 7 set
        default:      pos = 3'd0; // no bits set
    endcase
end

endmodule