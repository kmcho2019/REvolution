// Superior solution combining the benefits of both examples
module TopModule #(
    parameter OUTPUT_VALUE = 1'b0 // Parameter to specify the output value
)(
    output out // Output port
);
    assign out = OUTPUT_VALUE; // Simple and concise assign statement
endmodule