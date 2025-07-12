module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

reg [1:0] lut_out;

always @(*)
begin
    case ({a, b, c, d})
        4'b0000: lut_out = 2'b00; // 0
        4'b0001: lut_out = 2'b00; // 1
        4'b0010: lut_out = 2'b10; // 2
        4'b0011: lut_out = 2'b00; // 3 (never occurs)
        4'b0100: lut_out = 2'b00; // 4
        4'b0101: lut_out = 2'b00; // 5
        4'b0110: lut_out = 2'b00; // 6
        4'b0111: lut_out = 2'b10; // 7
        4'b1000: lut_out = 2'b00; // 8 (never occurs)
        4'b1001: lut_out = 2'b00; // 9
        4'b1010: lut_out = 2'b00; // 10
        4'b1011: lut_out = 2'b00; // 11 (never occurs)
        4'b1100: lut_out = 2'b00; // 12 (never occurs)
        4'b1101: lut_out = 2'b00; // 13
        4'b1110: lut_out = 2'b00; // 14
        4'b1111: lut_out = 2'b10; // 15
        default: lut_out = 2'b00;
    endcase
    out_sop = lut_out[1];
    out_pos = ~(|({a, b, c, d} == 4'b0000) | ({a, b, c, d} == 4'b0001) | ({a, b, c, d} == 4'b0100) | ({a, b, c, d} == 4'b0101) | ({a, b, c, d} == 4'b0110) | ({a, b, c, d} == 4'b1001) | ({a, b, c, d} == 4'b1010) | ({a, b, c, d} == 4'b1101) | ({a, b, c, d} == 4'b1110));
end

endmodule