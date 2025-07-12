module TopModule (
    input in1,
    input in2,
    output out
);
    wire not_in1;  // Intermediate wire for inverted in1

    // Invert in1
    assign not_in1 = ~in1;

    // NOR operation between inverted in1 and in2
    assign out = ~(not_in1 | in2);
endmodule