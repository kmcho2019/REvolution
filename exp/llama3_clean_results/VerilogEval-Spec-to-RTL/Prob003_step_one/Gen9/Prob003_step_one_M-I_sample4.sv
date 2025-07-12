module TopModule (
    output one
);
    // Specify the output as a constant driver to potentially allow for further synthesis optimization
    assign one = 1'b1;
    // Alternatively, using a parameter for the output value as in the original solution
    // parameter OUTPUT_VALUE = 1'b1;
    // assign one = OUTPUT_VALUE;
endmodule