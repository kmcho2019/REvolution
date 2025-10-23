module Inverter (
    input  wire a,
    output wire y
);
    // Simple combinational inverter
    assign y = ~a;
endmodule

module And2 (
    input  wire a,
    input  wire b,
    output wire y
);
    // Simple combinational 2-input AND gate
    assign y = a & b;
endmodule

module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    wire not_in2;

    // First stage: invert in2
    Inverter inv_stage (
        .a(in2),
        .y(not_in2)
    );

    // Second stage: AND in1 with inverted in2
    And2 and_stage (
        .a(in1),
        .b(not_in2),
        .y(out)
    );
endmodule