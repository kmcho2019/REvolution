module OrGate (
    input wire a,
    input wire b,
    output wire y
);
    assign y = a | b;
endmodule

module NotGate (
    input wire a,
    output wire y
);
    assign y = ~a;
endmodule

module TopModule (
    input wire in1,
    input wire in2,
    output wire out
);
    wire or_out;

    OrGate or_inst (
        .a(in1),
        .b(in2),
        .y(or_out)
    );

    NotGate not_inst (
        .a(or_out),
        .y(out)
    );
endmodule