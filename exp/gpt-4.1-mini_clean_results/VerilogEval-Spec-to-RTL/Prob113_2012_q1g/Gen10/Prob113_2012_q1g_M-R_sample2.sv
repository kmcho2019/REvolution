module TopModule(
    input  [3:0] x,
    output reg   f
);

always @(*) begin
    case (x)
        4'b0000: f = 1'b1; // x=0000, row=00 col=00
        4'b0010: f = 1'b1; // x=0010, row=00 col=10
        4'b1011: f = 1'b1; // x=1011, row=10 col=11 (0 in Karnaugh but careful, see mapping)
        4'b1000: f = 1'b1; // x=1000, row=10 col=00
        4'b1010: f = 1'b1; // x=1010, row=10 col=10
        4'b1100: f = 1'b1; // x=1100, row=11 col=00
        4'b1101: f = 1'b1; // x=1101, row=11 col=01
        4'b1110: f = 1'b0; // row=11 col=10
        4'b1111: f = 1'b1; // row=11 col=11
        default: f = 1'b0;
    endcase
end

endmodule