module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    // Implement out = (in1 XNOR in2) XOR in3 directly as a single assign statement
    assign out = (in1 ~^ in2) ^ in3;
endmodule