// Define TopModule using a lookup table (LUT)
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    reg [1:0] out_lut;

    always @(*) begin
        case ({a, b, c, d})
            4'b0000: out_lut = 2'b00;
            4'b0001: out_lut = 2'b00;
            4'b0010: out_lut = 2'b00;
            4'b0011: out_lut = 2'b01;
            4'b0100: out_lut = 2'b00;
            4'b0101: out_lut = 2'b01;
            4'b0110: out_lut = 2'b01;
            4'b0111: out_lut = 2'b01;
            4'b1000: out_lut = 2'b00;
            4'b1001: out_lut = 2'b01;
            4'b1010: out_lut = 2'b01;
            4'b1011: out_lut = 2'b01;
            4'b1100: out_lut = 2'b01;
            4'b1101: out_lut = 2'b01;
            4'b1110: out_lut = 2'b01;
            4'b1111: out_lut = 2'b01;
            default: out_lut = 2'b00;
        endcase
    end

    assign out = out_lut[0];
    assign out_n = ~out_lut[0];
endmodule