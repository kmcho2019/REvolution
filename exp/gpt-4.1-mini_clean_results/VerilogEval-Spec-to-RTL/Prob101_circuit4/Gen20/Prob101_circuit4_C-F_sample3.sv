module OrGate (
    input  wire x,
    input  wire y,
    output wire z
);
    or or_inst (z, x, y);
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    // a and d are unused; synthesis tools typically handle this silently.

    // Structural instantiation of OR gate for clarity and minimal logic
    OrGate or_gate_inst (
        .x(b),
        .y(c),
        .z(q)
    );
endmodule