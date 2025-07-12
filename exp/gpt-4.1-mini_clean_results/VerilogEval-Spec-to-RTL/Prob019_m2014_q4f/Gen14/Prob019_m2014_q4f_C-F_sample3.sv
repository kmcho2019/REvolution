module NotGate (
    input  wire a,
    output wire y
);
    // Simple continuous assignment for inverter, synthesis-friendly and clear
    assign y = ~a;
endmodule

module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Simple continuous assignment for AND gate, synthesis-friendly and clear
    assign y = a & b;
endmodule

module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    wire not_in2;

    // Explicit inversion of in2 to represent bubble
    NotGate u_not (
        .a(in2),
        .y(not_in2)
    );

    // AND gate combining in1 and inverted in2
    AndGate u_and (
        .a(in1),
        .b(not_in2),
        .y(out)
    );
endmodule