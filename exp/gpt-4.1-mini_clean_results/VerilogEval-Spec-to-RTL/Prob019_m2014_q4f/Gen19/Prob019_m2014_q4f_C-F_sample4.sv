module NotGate #(parameter DELAY = 0) (
    input  wire a,
    output wire y
);
    // Parameterized inverter with optional delay, synthesis-friendly
    assign #(DELAY) y = ~a;
endmodule

module AndGate #(parameter DELAY = 0) (
    input  wire a,
    input  wire b,
    output wire y
);
    // Parameterized AND gate with optional delay, synthesis-friendly
    assign #(DELAY) y = a & b;
endmodule

module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    wire not_in2;

    // Instantiate NotGate to explicitly show the bubble on in2
    NotGate #(.DELAY(0)) u_not (
        .a(in2),
        .y(not_in2)
    );

    // Use direct continuous assignment for AND combining in1 and inverted in2
    // This allows synthesis optimization without instantiating an explicit AndGate module
    assign out = in1 & not_in2;

endmodule