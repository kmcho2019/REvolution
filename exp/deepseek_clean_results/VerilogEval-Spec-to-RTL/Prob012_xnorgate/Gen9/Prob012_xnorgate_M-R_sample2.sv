module TopModule (
    input a,
    input b,
    output out
);
    // Parameterized LUT storing XNOR truth table (00->1, 01->0, 10->0, 11->1)
    parameter [3:0] XNOR_LUT = 4'b1001;
    
    // Continuous assignment using inputs as LUT address
    assign out = XNOR_LUT[{a, b}];
endmodule