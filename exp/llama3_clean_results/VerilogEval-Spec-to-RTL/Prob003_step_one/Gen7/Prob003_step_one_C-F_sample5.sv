// TopModule: Always drives output 'one' high.
module TopModule(
    output one
);

// Parameter for output value to make the design flexible.
parameter OUTPUT_VALUE = 1'b1;

// Assign constant value to output 'one' for simplicity and readability.
assign one = OUTPUT_VALUE;

endmodule