module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    // Combined logic for: out = XOR(XNOR(in1, in2), in3)
    assign out = (~(in1 ^ in2)) ^ in3;
endmodule