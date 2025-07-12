module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    // Optimal implementation using minimal gates:
    // out = XNOR(in1,in2) XOR in3
    assign out = (in1 ~^ in2) ^ in3;
endmodule