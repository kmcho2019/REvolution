module TopModule #(
    parameter OUTPUT_VALUE = 1'b1
) (
    output one
);
    assign one = OUTPUT_VALUE;
endmodule