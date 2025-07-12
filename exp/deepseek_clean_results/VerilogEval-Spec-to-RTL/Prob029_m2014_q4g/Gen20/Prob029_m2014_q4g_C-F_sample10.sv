module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    // Combined XNOR of in1/in2 then XOR with in3 in a single expression
    assign out = (~(in1 ^ in2)) ^ in3;
endmodule