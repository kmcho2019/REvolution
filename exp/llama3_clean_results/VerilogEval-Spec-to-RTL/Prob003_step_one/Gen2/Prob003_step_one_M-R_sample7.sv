// Module TopModule: This module always drives its output 'one' to a logic high (1).
// The implementation uses a continuous assignment for simplicity and efficiency.
module TopModule(
    output one // Output port that is always driven high
);

// Define a parameter for the output value to make the module slightly more flexible.
parameter OUTPUT_VALUE = 1'b1;

// Assign the output 'one' the value defined by the parameter.
assign one = OUTPUT_VALUE;

endmodule