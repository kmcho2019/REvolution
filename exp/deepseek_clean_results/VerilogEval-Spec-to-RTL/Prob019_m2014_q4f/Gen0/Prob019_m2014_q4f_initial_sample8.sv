module TopModule (
    input in1,
    input in2,
    output out
);
    wire not_in2;  // Intermediate wire for inverted in2

    // Invert in2
    assign not_in2 = ~in2;

    // AND operation between in1 and inverted in2
    assign out = in1 & not_in2;
endmodule