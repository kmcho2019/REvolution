module TopModule(
    input a,
    input b,
    output out
);
    // 4x1 LUT implementing AND function using continuous assignment
    wire [0:3] lut = 4'b0001; // Truth table: [00 01 10 11] -> [0 0 0 1]
    
    assign out = lut[{a,b}];
endmodule