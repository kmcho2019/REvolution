// Module TopModule: Parameterized module to drive the output "one" to a constant value
module TopModule #(
    parameter OUTPUT_VALUE = 1'b1
)(
    output one
);
    // Directly assign the output to the parameterized constant value
    assign one = OUTPUT_VALUE;
endmodule