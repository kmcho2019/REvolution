module NotGate #(parameter DELAY=0) (
    input  wire a,
    output wire y
);
    // Structural inversion with optional delay for clarity and synthesis friendliness
    assign #(DELAY) y = ~a;
endmodule

module AndGate #(parameter DELAY=0) (
    input  wire a,
    input  wire b,
    output wire y
);
    // Structural AND with optional delay for clarity and synthesis friendliness
    assign #(DELAY) y = a & b;
endmodule

module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    wire not_in2;

    // Instantiate NotGate to explicitly model the bubble (inversion) on in2
    NotGate u_not (
        .a(in2),
        .y(not_in2)
    );

    // Instantiate AndGate to combine in1 and inverted in2
    AndGate u_and (
        .a(in1),
        .b(not_in2),
        .y(out)
    );
endmodule