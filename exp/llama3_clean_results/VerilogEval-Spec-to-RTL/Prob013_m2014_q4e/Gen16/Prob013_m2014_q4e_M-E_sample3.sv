module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Internal wires for inverted inputs
    wire not_in1;
    wire not_in2;

    // Invert inputs
    assign not_in1 = ~in1;
    assign not_in2 = ~in2;

    // AND the inverted inputs to implement NOR
    assign out = not_in1 & not_in2;
endmodule