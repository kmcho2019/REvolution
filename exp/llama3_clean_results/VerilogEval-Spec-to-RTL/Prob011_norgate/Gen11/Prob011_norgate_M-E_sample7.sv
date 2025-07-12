// Novel Module TopModule implementing a NOR gate using OR and NOT gates.
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    output out  // Output signal out
);

// Internal wire for OR operation result.
wire or_result;  // Result of OR operation on inputs a and b

// Perform OR operation on inputs.
assign or_result = a | b;  // OR operation on inputs a and b

// Implement NOR by inverting OR result.
assign out = ~or_result;  // NOR operation by inverting OR result

endmodule