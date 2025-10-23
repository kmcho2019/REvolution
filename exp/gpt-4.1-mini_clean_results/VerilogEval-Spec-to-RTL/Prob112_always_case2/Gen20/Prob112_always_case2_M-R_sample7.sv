module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        casez (in)
            4'b???1: pos = 2'd0; // bit 0 is set
            4'b??10: pos = 2'd1; // bit 1 is set and bit0 is zero
            4'b?100: pos = 2'd2; // bit 2 is set and bits 0,1 zero
            4'b1000: pos = 2'd3; // bit 3 is set only if others zero
            default: pos = 2'd0; // no bits set
        endcase
    end

endmodule