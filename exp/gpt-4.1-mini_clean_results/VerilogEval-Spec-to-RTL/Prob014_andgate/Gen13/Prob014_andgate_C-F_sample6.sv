module AndGate #(
    parameter WIDTH = 2
) (
    input  wire [WIDTH-1:0] in,
    output wire out
);
    assign out = &in;  // AND reduction of all inputs
endmodule

module TopModule (
    input  a,
    input  b,
    output out
);
    wire [1:0] inputs = {a, b};
    AndGate #(.WIDTH(2)) and_inst (
        .in(inputs),
        .out(out)
    );
endmodule