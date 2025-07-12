module AndGate #(
    parameter WIDTH = 2
) (
    input  wire [WIDTH-1:0] in,
    output wire out
);
    assign out = &in;  // Reduction AND over inputs
endmodule

module TopModule (
    input  a,
    input  b,
    output out
);
    AndGate #(.WIDTH(2)) and_inst (
        .in({a, b}),
        .out(out)
    );
endmodule