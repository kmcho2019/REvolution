module OrGate2(
    input x,
    input y,
    output z
);
    or or_inst(z, x, y);
endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Structural OR gate instantiation for clean minimal combinational logic
    OrGate2 or_gate_inst(
        .x(b),
        .y(c),
        .z(q)
    );
endmodule