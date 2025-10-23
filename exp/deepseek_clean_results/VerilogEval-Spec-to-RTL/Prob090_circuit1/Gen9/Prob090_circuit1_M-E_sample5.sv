module TopModule (
    input a,
    input b,
    output q
);
    // Define AND function as a lookup table
    reg [0:3] lut;
    
    initial begin
        lut[0] = 1'b0; // a=0, b=0
        lut[1] = 1'b0; // a=0, b=1
        lut[2] = 1'b0; // a=1, b=0
        lut[3] = 1'b1; // a=1, b=1
    end
    
    // Use inputs as index into LUT
    assign q = lut[{a,b}];
endmodule