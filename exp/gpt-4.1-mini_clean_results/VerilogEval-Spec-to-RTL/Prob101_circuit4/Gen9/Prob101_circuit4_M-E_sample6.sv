module Buffer (
    input wire in,
    output wire out
);
    assign out = in;
endmodule

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
    wire buf_b;
    wire buf_c;

    Buffer buf_inst_b (
        .in(b),
        .out(buf_b)
    );

    Buffer buf_inst_c (
        .in(c),
        .out(buf_c)
    );

    OrGate2 or_inst (
        .x(buf_b),
        .y(buf_c),
        .z(q)
    );
endmodule