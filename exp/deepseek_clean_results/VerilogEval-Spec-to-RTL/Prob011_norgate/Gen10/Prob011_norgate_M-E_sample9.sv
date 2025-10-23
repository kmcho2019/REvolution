module TopModule (
    input a,
    input b,
    output out
);
    // 4-bit LUT containing NOR truth table (output for 00,01,10,11)
    reg [3:0] lut = 4'b1000; // NOR function: out = ~(a|b)
    
    always @(*) begin
        case ({a, b})
            2'b00: out = lut[0];
            2'b01: out = lut[1];
            2'b10: out = lut[2];
            2'b11: out = lut[3];
            default: out = 1'bx;
        endcase
    end
endmodule