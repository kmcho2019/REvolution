// TopModule: A parameterized module that drives a constant output value.
module TopModule #(
    parameter OUTPUT_VALUE = 1'b1 // Default output value is 1
)(
    output wire one // Explicitly declare 'one' as a wire for clarity and best practice
);

// Assign the parameter-defined constant value to the output 'one'.
assign one = OUTPUT_VALUE;

endmodule