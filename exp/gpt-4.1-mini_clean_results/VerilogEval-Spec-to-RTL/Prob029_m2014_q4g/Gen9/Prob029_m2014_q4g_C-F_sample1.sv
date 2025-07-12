module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    // Explicitly define intermediate wires matching gate function names for clarity
    wire xnor_out;
    // Implement XnorGate logic with continuous assignment (bitwise ~^)
    assign xnor_out = in1 ~^ in2;
    // Implement XorGate logic with continuous assignment
    assign out = xnor_out ^ in3;

endmodule