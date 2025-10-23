// TopModule with a parameterizable constant generator
module TopModule #(
    parameter DEFAULT_VALUE = 1'b0
) (
    output zero
);
// Assign the parameterized default value to the output port 'zero'
assign zero = DEFAULT_VALUE;
endmodule