// TopModule: Always drives output 'one' high, with flexibility and minimalism.
module TopModule #(
    parameter OUTPUT_VALUE = 1'b1
) (
    output one
);

// Directly assign the output value using the parameter.
assign one = OUTPUT_VALUE;

endmodule