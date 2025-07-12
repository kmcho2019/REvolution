module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // LUT implementation of the K-map
    reg [15:0] lut = 16'b0101_1010_0101_1010;
    
    assign out = lut[{a,b,c,d}];
endmodule