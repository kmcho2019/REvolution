module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    assign out_and = &(in); // using the reduction AND operator (&) to perform 4-input AND
    assign out_or = |(in);   // using the reduction OR operator (|) to perform 4-input OR
    assign out_xor = ^(in); // using the reduction XOR operator (^) to perform 4-input XOR
endmodule