module TopModule (
    input a,
    input b,
    output out
);
    // 2-input LUT implementation for XNOR
    // LUT configuration: 0x9 (1001 binary) for XNOR
    reg [3:0] lut = 4'b1001;  // XNOR truth table
    
    // Select the appropriate LUT output based on inputs
    assign out = lut[{a, b}];
endmodule