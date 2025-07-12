// TopModule: A configurable module that drives its output to a specified value.
// Parameters:
//   - OUTPUT_VALUE (default: 1'b1): The value to be driven on the output port.
module TopModule #(
    parameter OUTPUT_VALUE = 1'b1
)(
    output one
);
    // Directly assign the parameter-controlled value to the output port.
    // This approach allows for flexibility in the output value while maintaining simplicity.
    assign one = OUTPUT_VALUE;
endmodule