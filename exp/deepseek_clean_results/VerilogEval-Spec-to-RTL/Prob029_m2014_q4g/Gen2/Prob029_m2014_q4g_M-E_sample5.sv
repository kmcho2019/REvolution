module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    // Truth table for the function (XNOR(in1,in2) XOR in3)
    reg [0:7] lut = 8'b01101001; // Precomputed outputs for all input combinations
    
    assign out = lut[{in1, in2, in3}];

endmodule