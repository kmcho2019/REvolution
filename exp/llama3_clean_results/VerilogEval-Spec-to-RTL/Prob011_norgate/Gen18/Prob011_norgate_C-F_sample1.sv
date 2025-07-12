// TopModule that implements a NOR gate using a direct logical expression
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    // Directly implement the NOR operation as the inverse of an OR operation
    assign out = ~(a | b);
endmodule