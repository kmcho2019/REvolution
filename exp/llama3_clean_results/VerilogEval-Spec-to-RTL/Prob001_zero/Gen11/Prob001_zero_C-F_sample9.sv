// TopModule with synthesis directives for optimization
module TopModule (
    output zero
);
// Explicitly assign a constant LOW value to the output port 'zero'
// This assignment is optimized for synthesis and clearly indicates a single-bit output
assign zero = 1'b0;
endmodule