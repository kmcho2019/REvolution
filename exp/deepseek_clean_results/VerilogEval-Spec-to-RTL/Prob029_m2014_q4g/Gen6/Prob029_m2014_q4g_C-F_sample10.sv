module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    wire xnor_result = in1 ~^ in2;  // Clear and efficient XNOR operation
    assign out = xnor_result ^ in3; // Final XOR with clean separation
endmodule