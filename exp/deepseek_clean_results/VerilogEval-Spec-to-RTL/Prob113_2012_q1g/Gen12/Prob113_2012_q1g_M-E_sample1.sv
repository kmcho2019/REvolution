module TopModule(
    input [3:0] x,
    output f
);
    // LUT constructed from Karnaugh map:
    // Rows x[3:2]: 00, 01, 11, 10
    // Columns x[1:0]: 00, 01, 11, 10
    // Values are concatenated row-wise
    wire [15:0] lut = 16'b1001_0000_1110_1101;
    
    assign f = lut[x];
endmodule