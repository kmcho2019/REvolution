// TopModule: Always drives output 'one' high, using a parameterized constant.
module TopModule(
    output one
);
// Define a parameter for the constant value to be assigned to 'one'.
parameter OUTPUT_VALUE = 1'b1;
// Assign the parameterized constant value to the output 'one'.
assign one = OUTPUT_VALUE;
endmodule