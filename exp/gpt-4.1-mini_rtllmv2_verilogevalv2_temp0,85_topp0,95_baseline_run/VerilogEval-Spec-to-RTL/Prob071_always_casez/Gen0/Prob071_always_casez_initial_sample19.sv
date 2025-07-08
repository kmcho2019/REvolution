module TopModule (
    input  [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    casex (in)
        8'bxxxx_xxx1: pos = 3'd0;
        8'bxxxx_xx10: pos = 3'd1;
        8'bxxxx_x100: pos = 3'd2;
        8'bxxx_1000:  pos = 3'd3;
        8'bxx1_0000:  pos = 3'd4;
        8'bx1_00000:  pos = 3'd5;
        8'b1_000000:  pos = 3'd6;
        default:      pos = 3'd0;
    endcase
end

endmodule