module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    // XNOR of in1 and in2 can be written as equality check
    // Then XOR with in3
    assign out = (in1 == in2) ^ in3;
endmodule