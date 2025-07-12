module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    // Combined XNOR(in1,in2) XOR in3 operation
    assign out = (~(in1 ^ in2)) ^ in3;
endmodule