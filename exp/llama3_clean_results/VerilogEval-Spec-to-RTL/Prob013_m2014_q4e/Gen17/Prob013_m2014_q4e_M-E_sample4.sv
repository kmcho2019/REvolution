module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Internal wires to hold inverted inputs
    wire not_in1;
    wire not_in2;

    // Invert inputs using NOT gates
    assign not_in1 = ~in1;
    assign not_in2 = ~in2;

    // Combine inverted inputs using an AND gate
    assign out = not_in1 & not_in2;
endmodule