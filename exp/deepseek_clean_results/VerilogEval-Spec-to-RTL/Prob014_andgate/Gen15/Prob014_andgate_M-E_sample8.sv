module TopModule (
    input  a,
    input  b,
    output out
);
    // 4-bit LUT for all 2-input functions
    // Indexed as [b][a], initialized for AND function
    reg [0:3] lut = 4'b0001;  // AND function truth table
    
    // Use inputs as address to select output
    assign out = lut[{b, a}];
endmodule