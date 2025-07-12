// Module TopModule implements the boolean function z = (x^y) & x
module TopModule(
    input x,  // Input x
    input y,  // Input y
    output result  // Output result of the boolean function
);

// Assign the result of the boolean function to the output
assign result = (x ^ y) & x;

endmodule