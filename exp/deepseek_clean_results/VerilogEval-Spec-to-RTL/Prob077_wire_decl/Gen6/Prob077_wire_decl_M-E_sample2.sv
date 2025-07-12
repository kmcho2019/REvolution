module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // 16-bit LUT encoding the truth table for (a&b)|(c&d)
    // Index is {a,b,c,d}, MSB first
    reg [15:0] lut = 16'b1111111111111110;  // Only index 0000 outputs 0
    
    // Select the appropriate output bit
    assign out = lut[{a,b,c,d}];
    assign out_n = ~out;
endmodule