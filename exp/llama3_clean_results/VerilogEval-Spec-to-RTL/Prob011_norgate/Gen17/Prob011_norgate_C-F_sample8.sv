// TopModule that implements a NOR gate using a direct logical expression
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    // Directly implement the NOR operation using a logical expression
    assign out = ~(a | b);  // out is the inverse of (a OR b)
endmodule