module TopModule(
    output out
);

// Define a parameter for the output value to allow for easy modification
parameter OUTPUT_VALUE = 1'b0;

// Assign the output value using the parameter for versatility and simplicity
assign out = OUTPUT_VALUE;

endmodule