// Refactored module with the same functionality, using a different approach to assign the constant value.
module TopModule #(
    parameter WIDTH = 1 // Parameter for output width
) (
    output logic [WIDTH-1:0] one // Output with parameterized width
);

// Using a bitwise OR operation to assign a constant value to the output.
// This approach achieves the same result as the original assign statement.
assign one = -1; // -1 in binary is all ones, which for any width will set all bits to 1.

// Alternatively, the following could also be used, though it's less efficient and less clear than the above:
// assign one = ~(~0); // Inverting all zeros to get all ones.

endmodule