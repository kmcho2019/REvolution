// Novel TopModule using a parameterized approach
module TopModule #(
    parameter OUTPUT_VALUE = 1'b0 // Default output value is LOW
) (
    output zero
);
// Assign the output based on the parameterized value
assign zero = OUTPUT_VALUE;
endmodule