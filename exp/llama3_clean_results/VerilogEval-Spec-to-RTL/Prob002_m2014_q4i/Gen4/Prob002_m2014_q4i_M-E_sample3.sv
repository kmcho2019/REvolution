// Novel implementation using a parameterized module
module TopModule #(
    parameter OUTPUT_VALUE = 1'b0 // Parameter to specify the output value
)(
    output out // Output port
);

    // Assign the output 'out' to the parameterized value
    assign out = OUTPUT_VALUE;

endmodule