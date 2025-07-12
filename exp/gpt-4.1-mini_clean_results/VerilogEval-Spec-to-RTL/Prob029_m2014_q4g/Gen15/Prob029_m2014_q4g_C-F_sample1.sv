module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    // Implement: out = (in1 XNOR in2) XOR in3
    // Equivalent to: out = (~(in1 ^ in2)) ^ in3;
    assign out = (~(in1 ^ in2)) ^ in3;
endmodule