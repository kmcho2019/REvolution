module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

reg [1:0] lut_out;

always @(*) begin
    case ({a, b, c, d})
        4'b0000: lut_out = 2'b00;
        4'b0001: lut_out = 2'b00;
        4'b0010: lut_out = 2'b00;
        4'b0011: lut_out = 2'b01;
        4'b0100: lut_out = 2'b00;
        4'b0101: lut_out = 2'b01;
        4'b0110: lut_out = 2'b01;
        4'b0111: lut_out = 2'b01;
        4'b1000: lut_out = 2'b00;
        4'b1001: lut_out = 2'b01;
        4'b1010: lut_out = 2'b01;
        4'b1011: lut_out = 2'b01;
        4'b1100: lut_out = 2'b01;
        4'b1101: lut_out = 2'b01;
        4'b1110: lut_out = 2'b01;
        4'b1111: lut_out = 2'b01;
        default: lut_out = 2'b00;
    endcase
end

assign out = lut_out[0];
assign out_n = ~out;

endmodule