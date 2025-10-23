module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &(in); // Using built-in reduction AND operator
    assign out_or = |(in);  // Using built-in reduction OR operator
    assign out_xor = ^(^in); // Using built-in reduction XOR operator, note the double XOR to handle the case of an even number of 1's

endmodule