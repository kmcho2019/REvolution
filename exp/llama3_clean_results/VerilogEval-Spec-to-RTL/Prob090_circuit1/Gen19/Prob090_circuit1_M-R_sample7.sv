// TopModule: A combinational circuit implementing a logical AND operation
module TopModule(
    // Input signals
    input  logic a,
    input  logic b,
    // Output signal
    output logic q
);

// Directly assign the result of the AND operation to the output q
assign q = a & b;

endmodule