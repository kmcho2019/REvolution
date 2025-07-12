module NotGate (
    input  wire a,
    output wire y
);
    // Minimal synthesis-friendly inverter using continuous assignment
    assign y = ~a;
endmodule

module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Minimal synthesis-friendly AND gate using continuous assignment
    assign y = a & b;
endmodule

module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    wire not_in2;

    // Explicitly invert in2 to represent bubble
    NotGate u_not (
        .a(in2),
        .y(not_in2)
    );

    // AND gate with in1 and inverted in2 inputs
    AndGate u_and (
        .a(in1),
        .b(not_in2),
        .y(out)
    );
endmodule