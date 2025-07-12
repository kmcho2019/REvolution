module NotGate (
    input  wire a,
    output wire y
);
    assign y = ~a;
endmodule

module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a & b;
endmodule

module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    wire in2_inv;

    // Explicit bubble on in2 represented by inverter
    NotGate not_gate (
        .a(in2),
        .y(in2_inv)
    );

    // AND gate with one input inverted to model bubble on in2
    AndGate and_gate (
        .a(in1),
        .b(in2_inv),
        .y(out)
    );
endmodule