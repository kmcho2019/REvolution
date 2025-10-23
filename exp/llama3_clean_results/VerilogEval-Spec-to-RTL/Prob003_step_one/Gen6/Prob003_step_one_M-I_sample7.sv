// TopModule: Always drives output 'one' high.
module TopModule(
    output one
);

// Parameter for output value to make the design flexible and adaptable.
parameter OUTPUT_VALUE = 1'b1;

// Assign constant value to output 'one' for simplicity, readability, and performance.
assign one = OUTPUT_VALUE;

endmodule