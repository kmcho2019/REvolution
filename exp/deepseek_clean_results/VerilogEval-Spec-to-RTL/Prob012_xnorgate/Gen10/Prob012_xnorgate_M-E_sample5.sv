module TopModule (
    input a,
    input b,
    output out
);
    // LUT implementation of XNOR
    // Truth table: 00->1, 01->0, 10->0, 11->1
    reg [3:0] lut = 4'b1001;  // XNOR truth table
    
    assign out = lut[{a, b}];  // Use concatenated inputs as LUT address
endmodule