module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);
    always @(*) begin
        casez (in)
            4'b???1: pos = 2'd0; // bit0 set
            4'b??10: pos = 2'd1; // bit1 set, bit0 clear
            4'b?100: pos = 2'd2; // bit2 set, bits1 and 0 clear
            4'b1000: pos = 2'd3; // bit3 set, bits2..0 clear
            default: pos = 2'd0; // no bits set
        endcase
    end
endmodule