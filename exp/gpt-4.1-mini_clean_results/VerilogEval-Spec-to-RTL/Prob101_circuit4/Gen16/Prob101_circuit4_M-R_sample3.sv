module Or2 (
    input wire x,
    input wire y,
    output wire z
);
    assign z = x | y;
endmodule

module Buf1 (
    input wire in,
    output wire out
);
    assign out = in;
endmodule

module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    wire or_out;

    // Instantiate a 2-input OR gate for b and c
    Or2 or_gate_inst (
        .x(b),
        .y(c),
        .z(or_out)
    );

    // Buffer the OR output to q
    Buf1 buf_inst (
        .in(or_out),
        .out(q)
    );

    // Inputs a and d are unused as per the behavior from the waveform
endmodule