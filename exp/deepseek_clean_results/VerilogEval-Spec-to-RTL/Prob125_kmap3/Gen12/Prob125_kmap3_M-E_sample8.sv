module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // 16-entry LUT implementing the truth table
    // Index is {a,b,c,d} but d is don't-care
    reg [15:0] lut = 16'b0001_1101_1111_0111;
    
    assign out = lut[{a,b,c,d}];
endmodule