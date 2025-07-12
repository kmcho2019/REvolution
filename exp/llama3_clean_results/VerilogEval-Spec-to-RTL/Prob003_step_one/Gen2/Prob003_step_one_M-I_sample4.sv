// TopModule: Always drives output 'one' high.
module TopModule(
    output one
);

// Assign constant value 1 to output 'one'.
// This ensures 'one' is always driven high.
assign one = 1'b1;

endmodule