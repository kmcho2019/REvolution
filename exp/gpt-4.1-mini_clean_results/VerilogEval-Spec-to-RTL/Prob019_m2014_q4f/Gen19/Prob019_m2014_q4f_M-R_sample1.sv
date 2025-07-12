module NotGate #(parameter DELAY = 0) (
    input  wire a,
    output wire y
);
    assign #(DELAY) y = ~a;
endmodule

module AndGate #(parameter DELAY = 0) (
    input  wire a,
    input  wire b,
    output wire y
);
    assign #(DELAY) y = a & b;
endmodule

module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    wire not_in2;

    // Instantiate NotGate to invert in2
    NotGate #() U_NOT (
        .a(in2),
        .y(not_in2)
    );

    // Instantiate AndGate to AND in1 and inverted in2
    AndGate #() U_AND (
        .a(in1),
        .b(not_in2),
        .y(out)
    );

endmodule