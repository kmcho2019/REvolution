module TopModule (
    input a,
    input b,
    output out
);
    // Direct and optimal XNOR implementation (equivalent to LUT[4'b1001])
    assign out = ~(a ^ b);
    
    /* Alternative LUT-based implementation (for reference):
    parameter [3:0] XNOR_LUT = 4'b1001;
    assign out = XNOR_LUT[{a, b}];
    */
endmodule