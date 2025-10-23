// TopModule that directly implements a NOR gate
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    // Directly assign the NOR gate logic using an OR gate and an inverter
    assign out = ~(a | b);  // Invert the result of the OR operation
endmodule