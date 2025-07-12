module OrGate2 (
    input wire x,
    input wire y,
    output wire z
);
    assign z = x | y;
endmodule

module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    OrGate2 or_inst (
        .x(b),
        .y(c),
        .z(q)
    );
endmodule