module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // 4-input LUT implementation
    // Index is {a,b,c,d}, output is (a&b)|(c&d)
    wire [3:0] address = {a,b,c,d};
    
    reg lut_out;
    always @(*) begin
        case(address)
            4'b0000: lut_out = 1'b0;
            4'b0001: lut_out = 1'b0;
            4'b0010: lut_out = 1'b0;
            4'b0011: lut_out = 1'b1;
            4'b0100: lut_out = 1'b0;
            4'b0101: lut_out = 1'b0;
            4'b0110: lut_out = 1'b0;
            4'b0111: lut_out = 1'b1;
            4'b1000: lut_out = 1'b0;
            4'b1001: lut_out = 1'b0;
            4'b1010: lut_out = 1'b0;
            4'b1011: lut_out = 1'b1;
            4'b1100: lut_out = 1'b1;
            4'b1101: lut_out = 1'b1;
            4'b1110: lut_out = 1'b1;
            4'b1111: lut_out = 1'b1;
            default: lut_out = 1'b0;
        endcase
    end
    
    assign out = lut_out;
    assign out_n = ~lut_out;
endmodule