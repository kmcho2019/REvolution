module NotGate #(parameter DELAY = 0) (
    input  wire a,
    output wire y
);
    // Parameterized inverter using continuous assign for synthesis friendliness
    assign #(DELAY) y = ~a;
endmodule

module AndGate #(parameter DELAY = 0) (
    input  wire a,
    input  wire b,
    output wire y
);
    // Parameterized AND gate using continuous assign for synthesis friendliness
    assign #(DELAY) y = a & b;
endmodule

module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    wire not_in2;

    // Instantiate NotGate for explicit bubble (inversion) on in2
    NotGate #(.DELAY(0)) u_not (
        .a(in2),
        .y(not_in2)
    );

    // Instantiate AndGate to combine in1 and inverted in2
    AndGate #(.DELAY(0)) u_and (
        .a(in1),
        .b(not_in2),
        .y(out)
    );
endmodule