module NorGate (
    input  wire a,
    input  wire b,
    output wire y
);
    nor (y, a, b);
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    wire nota, notb;

    // Invert a using NOR gate with tied inputs
    NorGate nor_not_a (
        .a(a),
        .b(a),
        .y(nota)
    );

    // Invert b using NOR gate with tied inputs
    NorGate nor_not_b (
        .a(b),
        .b(b),
        .y(notb)
    );

    // NOR of inverted inputs (i.e., AND function)
    NorGate nor_and (
        .a(nota),
        .b(notb),
        .y(q)
    );
endmodule