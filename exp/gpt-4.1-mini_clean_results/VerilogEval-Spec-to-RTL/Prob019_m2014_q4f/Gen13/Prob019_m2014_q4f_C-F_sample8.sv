module NotGate (
    input  wire a,
    output wire y
);
    // Pure combinational inverter using continuous assignment
    assign y = ~a;
endmodule

module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Pure combinational AND gate using continuous assignment
    assign y = a & b;
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