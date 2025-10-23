// TopModule: Always drives output 'one' high.
module TopModule(
    output one
);

// Parameter for output value, allowing flexibility if needed
parameter OUTPUT_VALUE = 1'b1;

// Assign parameterized constant value to output 'one'.
// This ensures 'one' is always driven high or to the specified value.
assign one = OUTPUT_VALUE;

endmodule