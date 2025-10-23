module TopModule (
    output one
);
// Define a parameter for the output value
parameter OUTPUT_VALUE = 1'b1;

// Assign the parameter value to the output
assign one = OUTPUT_VALUE;

endmodule