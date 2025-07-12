module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    // LUT implementation of the function: (in1 XNOR in2) XOR in3
    reg [7:0] lut = 8'b01101001; // Precomputed truth table
    
    assign out = lut[{in1, in2, in3}];

endmodule