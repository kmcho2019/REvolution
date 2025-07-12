// TopModule: Always drives output 'one' high, combining simplicity with parameterized constant.
module TopModule (
    output logic one
);

// Define a parameter with the constant value.
parameter logic HIGH_VALUE = 1'b1;

// Assign the parameter value to the output 'one'.
assign one = HIGH_VALUE;

endmodule