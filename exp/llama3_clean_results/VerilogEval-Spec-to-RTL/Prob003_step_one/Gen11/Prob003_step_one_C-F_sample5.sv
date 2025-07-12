module TopModule #(
    parameter OUTPUT_VALUE = 1'b1
) (
    output one
);
    // Directly assign the parameter value to the output
    assign one = OUTPUT_VALUE;

endmodule