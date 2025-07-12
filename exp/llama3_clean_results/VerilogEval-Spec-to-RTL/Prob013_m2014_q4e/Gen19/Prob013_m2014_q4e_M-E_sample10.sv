module TopModule(
    input  in1,
    input  in2,
    output out
);
    wire not_in1;
    wire not_in2;

    // Invert the inputs
    assign not_in1 = ~in1;
    assign not_in2 = ~in2;

    // Apply AND operation to the inverted inputs
    assign out = not_in1 & not_in2;
endmodule