// TopModule: A module that drives its output high, with parameter for output value.
module TopModule(
    output one
);

// Define a parameter for the output value.
parameter OUTPUT_HIGH = 1'b1;

// Directly assign the parameter value to the output port.
assign one = OUTPUT_HIGH;

endmodule