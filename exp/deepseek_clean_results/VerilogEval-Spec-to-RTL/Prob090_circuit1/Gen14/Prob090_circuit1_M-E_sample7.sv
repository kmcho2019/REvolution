module TopModule (
    input  a,
    input  b,
    output q
);
    // 4-bit memory storing AND truth table
    reg [0:3] lut;
    
    initial begin
        lut[0] = 0; // a=0, b=0
        lut[1] = 0; // a=0, b=1
        lut[2] = 0; // a=1, b=0
        lut[3] = 1; // a=1, b=1
    end
    
    assign q = lut[{a,b}];
endmodule