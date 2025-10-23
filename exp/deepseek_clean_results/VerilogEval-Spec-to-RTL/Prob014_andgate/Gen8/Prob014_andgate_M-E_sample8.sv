module TopModule(
    input a,
    input b,
    output out
);
    // 4x1 LUT implementing AND function
    reg [0:3] lut;
    
    initial begin
        lut[0] = 1'b0; // 00
        lut[1] = 1'b0; // 01
        lut[2] = 1'b0; // 10
        lut[3] = 1'b1; // 11
    end
    
    assign out = lut[{a,b}];
endmodule