module TopModule (
    input in,
    output out
);
    // LUT implementation of NOT gate
    // Index 0: in=0 → out=1
    // Index 1: in=1 → out=0
    reg [1:0] lut = 2'b10;  // NOT gate truth table
    
    assign out = lut[in];
endmodule