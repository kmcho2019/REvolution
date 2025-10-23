// Define the module comparator_4bit with input ports A and B, and output ports A_greater, A_equal, A_less
module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Use wire to declare internal signals
wire [3:0] result;

// Perform subtraction A - B
assign result = A - B;

// Determine the comparison result
assign A_greater = (result > 0);
assign A_equal = (result == 0);
assign A_less = (result < 0);

endmodule