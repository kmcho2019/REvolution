module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    // Implement: (in1 XNOR in2) XOR in3
    // Using single continuous assignment for optimal PPA
    assign out = (~(in1 ^ in2)) ^ in3;
endmodule