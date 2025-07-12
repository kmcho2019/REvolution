module TopModule #(
    parameter OUTPUT_VALUE = 1'b0
) (
    output zero
);
// Use the parameter to assign the output port 'zero'
assign zero = OUTPUT_VALUE;
endmodule