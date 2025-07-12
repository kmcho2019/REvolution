module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    wire stage1 = in1 ~^ in2;  // Clear XNOR stage
    assign out = stage1 ^ in3; // Final XOR stage
endmodule