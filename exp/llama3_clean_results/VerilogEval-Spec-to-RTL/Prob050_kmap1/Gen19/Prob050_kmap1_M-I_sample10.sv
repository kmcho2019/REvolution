// Improved solution maintaining efficiency and optimizing for readability
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    input  c,  // Input signal c
    output out  // Output signal out
);

// Maintain the efficient and straightforward OR gate logic
// This implementation is optimal for area and performance
assign out = (a || b || c);  // Use || operator for clarity and readability

endmodule