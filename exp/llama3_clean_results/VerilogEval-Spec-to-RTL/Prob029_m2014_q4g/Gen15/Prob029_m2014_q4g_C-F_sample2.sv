module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Combine the XNOR operation using bitwise XOR (~^) with the subsequent XOR operation (^) in a single statement
assign out = (~in1 ^ in2) ^ in3;

endmodule