module TopModule (
    output one
);
// Define the output as a constant to potentially reduce area
localparam OUTPUT_VALUE = 1'b1;
// Directly assign the constant value to the output
assign one = OUTPUT_VALUE;

endmodule