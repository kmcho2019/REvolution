module Inverter (
    input wire a,
    output wire y
);
    assign y = ~a;
endmodule

module OrGate (
    input wire a,
    input wire b,
    output wire y
);
    assign y = a | b;
endmodule

module TopModule (
    input in1,
    input in2,
    output out
);
    wire or_out;
    OrGate or_gate_inst (
        .a(in1),
        .b(in2),
        .y(or_out)
    );

    Inverter inv_inst (
        .a(or_out),
        .y(out)
    );
endmodule