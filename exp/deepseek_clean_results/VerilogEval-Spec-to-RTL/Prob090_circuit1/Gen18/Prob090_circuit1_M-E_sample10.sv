module TopModule (
    input  a,
    input  b,
    output q
);
    // Implement as a 2-input LUT (lookup table)
    reg [0:3] lut = 4'b0001; // Truth table for AND function
    
    assign q = lut[{a,b}]; // Use input concatenation as LUT address
endmodule