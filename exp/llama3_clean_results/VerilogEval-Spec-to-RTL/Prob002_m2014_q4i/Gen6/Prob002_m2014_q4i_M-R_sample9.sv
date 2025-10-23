module TopModule(
    output out
);

// Using an initial block to set the output, which is less common for constant assignments
// but demonstrates an alternative approach.
initial out = 1'b0;

// Alternatively, if considering future changes or parametrization:
// parameter OUTPUT_VALUE = 1'b0;
// assign out = OUTPUT_VALUE;

endmodule