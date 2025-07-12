// Module TopModule implements a NOR gate using an always block.
// The inputs are 'a' and 'b', and the output is 'out'.
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    output out  // Output signal out
);

// Use an always block to continuously assign the result of the inversion of the OR operation to the output.
always @(*) begin
    out = ~(a | b);  // NOR operation assigned to out within the always block
end

// This implementation achieves the NOR operation using an always block for continuous assignment,
// providing an alternative structure while maintaining the functionality.

endmodule