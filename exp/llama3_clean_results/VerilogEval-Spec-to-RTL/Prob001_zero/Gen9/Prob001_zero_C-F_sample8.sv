module TopModule #(
    parameter OUTPUT_VALUE = 1'b0
) (
    output logic zero
);
assign zero = OUTPUT_VALUE;
endmodule