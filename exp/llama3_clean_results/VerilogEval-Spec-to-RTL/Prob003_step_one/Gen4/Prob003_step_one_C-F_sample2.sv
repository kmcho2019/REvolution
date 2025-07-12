// TopModule: Always drives output 'one' high.
module TopModule #(
    parameter OUTPUT_VALUE = 1'b1
)(
    output one
);
    // Directly assign the parameterized value to the output port
    assign one = OUTPUT_VALUE;
endmodule