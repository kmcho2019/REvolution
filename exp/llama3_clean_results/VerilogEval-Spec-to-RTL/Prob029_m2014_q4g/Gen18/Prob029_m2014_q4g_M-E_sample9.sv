module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Use a single wire for the output
wire result;

// Conditional assignment based on the truth table
assign result = (in1 == in2) ^ in3;

// Assign the result to the output
assign out = result;

endmodule