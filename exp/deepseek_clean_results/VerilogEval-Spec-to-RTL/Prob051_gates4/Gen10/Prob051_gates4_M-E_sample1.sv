module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    reg [2:0] lut_out;
    
    always @(*) begin
        case(in)
            4'b0000: lut_out = 3'b000;
            4'b0001: lut_out = 3'b001;
            4'b0010: lut_out = 3'b001;
            4'b0011: lut_out = 3'b011;
            4'b0100: lut_out = 3'b001;
            4'b0101: lut_out = 3'b001;
            4'b0110: lut_out = 3'b001;
            4'b0111: lut_out = 3'b011;
            4'b1000: lut_out = 3'b001;
            4'b1001: lut_out = 3'b001;
            4'b1010: lut_out = 3'b001;
            4'b1011: lut_out = 3'b011;
            4'b1100: lut_out = 3'b001;
            4'b1101: lut_out = 3'b011;
            4'b1110: lut_out = 3'b011;
            4'b1111: lut_out = 3'b111;
            default: lut_out = 3'b000;
        endcase
    end
    
    assign {out_xor, out_or, out_and} = lut_out;

endmodule