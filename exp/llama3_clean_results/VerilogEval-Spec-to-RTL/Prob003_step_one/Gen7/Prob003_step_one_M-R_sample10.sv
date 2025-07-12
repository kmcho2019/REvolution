module TopModule #(
    parameter OUTPUT_VALUE = 1'b1
)(
    output one
);
    wire output_signal = OUTPUT_VALUE;
    assign one = output_signal;
endmodule