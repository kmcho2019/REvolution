module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    // First 4-input NAND implemented as LUT
    wire [3:0] p1_sel = {p1a, p1b, p1c, p1d};
    reg p1_lut_out;
    always @(*) begin
        case (p1_sel)
            4'b0000: p1_lut_out = 1'b1;
            4'b0001: p1_lut_out = 1'b1;
            4'b0010: p1_lut_out = 1'b1;
            4'b0011: p1_lut_out = 1'b1;
            4'b0100: p1_lut_out = 1'b1;
            4'b0101: p1_lut_out = 1'b1;
            4'b0110: p1_lut_out = 1'b1;
            4'b0111: p1_lut_out = 1'b1;
            4'b1000: p1_lut_out = 1'b1;
            4'b1001: p1_lut_out = 1'b1;
            4'b1010: p1_lut_out = 1'b1;
            4'b1011: p1_lut_out = 1'b1;
            4'b1100: p1_lut_out = 1'b1;
            4'b1101: p1_lut_out = 1'b1;
            4'b1110: p1_lut_out = 1'b1;
            4'b1111: p1_lut_out = 1'b0;
            default: p1_lut_out = 1'b1;
        endcase
    end
    assign p1y = p1_lut_out;

    // Second 4-input NAND implemented as LUT
    wire [3:0] p2_sel = {p2a, p2b, p2c, p2d};
    reg p2_lut_out;
    always @(*) begin
        case (p2_sel)
            4'b0000: p2_lut_out = 1'b1;
            4'b0001: p2_lut_out = 1'b1;
            4'b0010: p2_lut_out = 1'b1;
            4'b0011: p2_lut_out = 1'b1;
            4'b0100: p2_lut_out = 1'b1;
            4'b0101: p2_lut_out = 1'b1;
            4'b0110: p2_lut_out = 1'b1;
            4'b0111: p2_lut_out = 1'b1;
            4'b1000: p2_lut_out = 1'b1;
            4'b1001: p2_lut_out = 1'b1;
            4'b1010: p2_lut_out = 1'b1;
            4'b1011: p2_lut_out = 1'b1;
            4'b1100: p2_lut_out = 1'b1;
            4'b1101: p2_lut_out = 1'b1;
            4'b1110: p2_lut_out = 1'b1;
            4'b1111: p2_lut_out = 1'b0;
            default: p2_lut_out = 1'b1;
        endcase
    end
    assign p2y = p2_lut_out;

endmodule