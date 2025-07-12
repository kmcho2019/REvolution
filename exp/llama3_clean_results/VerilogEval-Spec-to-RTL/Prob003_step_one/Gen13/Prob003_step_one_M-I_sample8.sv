// Improved module with parameterization for output width and additional documentation.
module TopModule #(
    parameter WIDTH = 1 // Parameter for output width
) (
    output logic [WIDTH-1:0] one // Output with parameterized width
);

// Direct assignment of a constant value to the output, taking into account the parameterized width.
// For a WIDTH of 1, this behaves the same as the original module.
assign one = {WIDTH{1'b1}};

endmodule