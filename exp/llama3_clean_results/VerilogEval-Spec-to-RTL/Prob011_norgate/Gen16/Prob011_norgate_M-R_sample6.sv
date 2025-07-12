// TopModule that implements a NOR gate directly using assign statements
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    // Directly implement the NOR gate using an OR gate followed by an inverter
    assign out = ~(a | b);
endmodule