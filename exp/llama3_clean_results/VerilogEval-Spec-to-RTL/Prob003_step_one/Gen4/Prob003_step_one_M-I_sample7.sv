// TopModule: Always drives output 'one' high.
module TopModule(
    output one
);

// Assign constant value 1 to output 'one'.
// This ensures 'one' is always driven high.
// Using a parameter for the output value could make the design more flexible.
parameter OUTPUT_VALUE = 1'b1;
assign one = OUTPUT_VALUE;

endmodule