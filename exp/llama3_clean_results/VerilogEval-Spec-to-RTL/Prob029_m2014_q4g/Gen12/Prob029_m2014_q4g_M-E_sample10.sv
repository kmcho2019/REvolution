module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Derive the unified Boolean expression based on the circuit's truth table
// The output 'out' is the XOR of 'in3' and the XNOR of 'in1' and 'in2'
// The XNOR of 'in1' and 'in2' can be represented as !(in1 ^ in2)
// Therefore, the unified expression becomes: out = !(in1 ^ in2) ^ in3
assign out = (!(in1 ^ in2)) ^ in3;

endmodule