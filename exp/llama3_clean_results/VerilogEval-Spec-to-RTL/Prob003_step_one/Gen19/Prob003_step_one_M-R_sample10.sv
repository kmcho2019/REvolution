// TopModule: A parameterized module that drives a constant output value.
module TopModule #(
    parameter OUTPUT_VALUE = 1'b1 // Default output value is 1
)(
    output logic one // Specify output type for clarity
);

// Continuous assignment for the output 'one' to enhance readability
assign one = OUTPUT_VALUE;

endmodule