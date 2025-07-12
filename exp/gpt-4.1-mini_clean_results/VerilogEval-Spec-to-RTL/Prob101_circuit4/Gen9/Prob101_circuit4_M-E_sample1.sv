module Inverter (
    input wire in,
    output wire out
);
    assign out = ~in;
endmodule

module AndGate2 (
    input wire x,
    input wire y,
    output wire z
);
    assign z = x & y;
endmodule

module OrGate2 (
    input wire x,
    input wire y,
    output wire z
);
    assign z = x | y;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,  // unused in logic
    output wire q
);

    wire not_a;
    wire b_and_not_a;

    Inverter inv_inst (
        .in(a),
        .out(not_a)
    );

    AndGate2 and_inst (
        .x(b),
        .y(not_a),
        .z(b_and_not_a)
    );

    OrGate2 or_inst (
        .x(b_and_not_a),
        .y(c),
        .z(q)
    );

endmodule