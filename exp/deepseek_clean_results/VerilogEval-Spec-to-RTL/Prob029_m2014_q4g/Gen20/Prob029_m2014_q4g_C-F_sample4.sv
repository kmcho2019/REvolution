module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    // First XNOR in1 and in2, then XOR the result with in3
    assign out = (~(in1 ^ in2)) ^ in3;
endmodule