// Simplified TopModule that directly implements a NOR gate
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    assign out = ~(a | b);  // Direct NOR operation using logical NOR operator
endmodule