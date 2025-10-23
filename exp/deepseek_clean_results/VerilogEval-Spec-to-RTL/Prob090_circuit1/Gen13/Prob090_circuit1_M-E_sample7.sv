module TopModule (
    input a,
    input b,
    output q
);
    // 4-bit LUT representing AND truth table
    reg [3:0] lut = 4'b0001;
    
    // Use input concatenation as address
    assign q = lut[{a, b}];
endmodule