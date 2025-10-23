// TopModule: A parameterized module that drives a constant output value.
module TopModule #(
    parameter OUTPUT_VALUE = 1'b1 // Default output value is 1
)(
    output one
);

// Assign the parameter-defined constant value to the output 'one'.
assign one = OUTPUT_VALUE;

endmodule