// TopModule: Always drives output 'one' high, alternative structure using a parameter.
module TopModule(
    output one
);

// Define a parameter with the constant value.
parameter HIGH_VALUE = 1'b1;

// Assign the parameter value to the output 'one'.
assign one = HIGH_VALUE;

endmodule