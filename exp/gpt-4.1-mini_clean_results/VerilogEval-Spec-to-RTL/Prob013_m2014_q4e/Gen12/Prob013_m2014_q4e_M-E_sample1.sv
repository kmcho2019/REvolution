module NotGate (
    input wire a,
    output wire y
);
    assign y = ~a;
endmodule

module AndGate (
    input wire a,
    input wire b,
    output wire y
);
    assign y = a & b;
endmodule

module TopModule (
    input wire in1,
    input wire in2,
    output wire out
);
    wire not_in1, not_in2;

    NotGate u_not1 (
        .a(in1),
        .y(not_in1)
    );

    NotGate u_not2 (
        .a(in2),
        .y(not_in2)
    );

    AndGate u_and (
        .a(not_in1),
        .b(not_in2),
        .y(out)
    );
endmodule