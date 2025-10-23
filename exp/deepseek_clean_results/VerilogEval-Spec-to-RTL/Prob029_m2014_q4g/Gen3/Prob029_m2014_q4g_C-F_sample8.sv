module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

    // Optimal fused implementation: clear XNOR operator with direct XOR
    assign out = (in1 ~^ in2) ^ in3;

endmodule