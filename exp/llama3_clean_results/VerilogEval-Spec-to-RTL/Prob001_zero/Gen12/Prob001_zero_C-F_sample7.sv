module TopModule #(
    parameter OUTPUT_VALUE = 1'b0
)(
    output zero
);
    // Explicitly assign the parameter value to the output port 'zero'
    assign zero = OUTPUT_VALUE;
endmodule