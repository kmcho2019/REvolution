module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    // LUT-based implementation using multiplexers
    wire [7:0] lut = 8'b10010110; // Precomputed truth table
    
    assign out = lut[{in1, in2, in3}];
endmodule