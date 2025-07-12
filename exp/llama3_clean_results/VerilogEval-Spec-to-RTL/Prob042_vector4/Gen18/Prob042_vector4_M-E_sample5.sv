module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Check the MSB of the input
    wire msb = in[7];

    // If MSB is '1', shift '1' 24 places to the left and perform a bitwise OR operation with the input
    // If MSB is '0', use the input as it is
    assign out = (msb) ? ({24{1'b1}} | (in)) : ({24{1'b0}} | (in));

    // Alternatively, you can use the following implementation
    // assign out = (msb) ? ({8{1'b1}}, in) : ({24{1'b0}}, in);

endmodule