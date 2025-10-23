module TopModule (
    input a,
    input b,
    output out
);
    // Implement XNOR using a 4x1 LUT
    reg [3:0] lut;
    
    initial begin
        // Initialize LUT with XNOR truth table (0x9 = 1001)
        // Index 0 (00): 1 (a=0, b=0 -> out=1)
        // Index 1 (01): 0 (a=0, b=1 -> out=0)
        // Index 2 (10): 0 (a=1, b=0 -> out=0)
        // Index 3 (11): 1 (a=1, b=1 -> out=1)
        lut = 4'b1001;
    end
    
    // Use input combination as address
    assign out = lut[{a, b}];
endmodule