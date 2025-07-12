module TopModule #(
    parameter OUTPUT_VALUE = 1'b1
) (
    output one
);
    // Direct assignment is already optimized for synthesis
    assign one = OUTPUT_VALUE;
endmodule