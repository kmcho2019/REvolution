module TopModule (
    input  a,
    input  b,
    output out
);
    // 2-bit LUT implementation of AND function
    reg [3:0] lut = 4'b0001;  // AND truth table: [00]=0, [01]=0, [10]=0, [11]=1
    
    always @(*) begin
        case ({a, b})
            2'b00: out = lut[0];
            2'b01: out = lut[1];
            2'b10: out = lut[2];
            2'b11: out = lut[3];
        endcase
    end
endmodule