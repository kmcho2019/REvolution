module TopModule (
    input a,
    input b,
    output out
);
    // 4-bit LUT storing XNOR truth table (00->1, 01->0, 10->0, 11->1)
    reg [3:0] lut = 4'b1001;
    
    // Use inputs as address to select the correct output
    assign out = lut[{a, b}];
endmodule