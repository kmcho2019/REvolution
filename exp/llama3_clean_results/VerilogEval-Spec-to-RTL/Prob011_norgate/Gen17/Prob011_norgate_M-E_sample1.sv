// TopModule implements a NOR gate using bitwise operations.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Use bitwise operations to implement the NOR logic.
assign out = ~(a | b);

// This implementation leverages the properties of bitwise operators to achieve the NOR operation.
endmodule