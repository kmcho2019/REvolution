module TopModule(
    input [3:0] in,
    output [1:0] pos
);

always @(*)
begin
    case (1'b1)
        in[3]: pos = 2'b11; // bit 3 is 1, so position is 3
        in[2]: pos = 2'b10; // bit 2 is 1, so position is 2
        in[1]: pos = 2'b01; // bit 1 is 1, so position is 1
        in[0]: pos = 2'b00; // bit 0 is 1, so position is 0
        default: pos = 2'b00; // no 1 bits found, so position is 0
    endcase
end

endmodule