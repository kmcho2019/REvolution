// TopModule: A combinational circuit implementing a logical AND operation
module TopModule(
    // Input signals
    input  logic a,
    input  logic b,
    // Output signal
    output logic q
);

// Assign the output q to be the logical AND of inputs a and b
assign q = a & b;

endmodule