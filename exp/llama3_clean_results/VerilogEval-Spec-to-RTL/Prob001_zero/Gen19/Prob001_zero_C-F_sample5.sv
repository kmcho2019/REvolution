// Define a parameterized module for a constant output that can be of any width.
module ConstantOutput #(
    parameter WIDTH = 1,  // Default width is 1 bit
    parameter bit OUTPUT_VALUE = 1'b0  // Default output value is LOW
) (
    output [WIDTH-1:0] zero
);
    // Assign the constant value to all bits of the output.
    assign zero = {WIDTH{OUTPUT_VALUE}};
endmodule

// Instantiate the ConstantOutput module with the desired width and output value.
module TopModule (
    output zero
);
    // Since the output width is 1, we can directly connect it to the output port.
    wire [0:0] internal_zero;
    ConstantOutput #(.WIDTH(1), .OUTPUT_VALUE(1'b0)) u_constant_output (
        .zero(internal_zero)
    );
    assign zero = internal_zero[0];
endmodule