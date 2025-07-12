module OrGate2(
    input wire x,
    input wire y,
    output wire z
);
    or or_inst(z, x, y);
endmodule

module TopModule(
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    // q is high if either b or c is high
    OrGate2 or_gate_inst(
        .x(b),
        .y(c),
        .z(q)
    );
endmodule