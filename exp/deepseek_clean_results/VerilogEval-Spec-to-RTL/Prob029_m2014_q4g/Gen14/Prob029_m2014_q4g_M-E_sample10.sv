module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    // Define LUT for the function: (in1 XNOR in2) XOR in3
    // Truth table index is {in3, in2, in1}
    reg [7:0] lut = 8'b01101001; // Precomputed truth table
    
    assign out = lut[{in3, in2, in1}];
endmodule