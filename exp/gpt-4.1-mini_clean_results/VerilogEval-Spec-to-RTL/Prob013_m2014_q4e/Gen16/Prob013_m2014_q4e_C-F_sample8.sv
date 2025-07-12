module OrGate #(
    parameter WIDTH = 1
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [WIDTH-1:0] y
);
    assign y = a | b;
endmodule

module NotGate #(
    parameter WIDTH = 1
) (
    input  wire [WIDTH-1:0] a,
    output wire [WIDTH-1:0] y
);
    assign y = ~a;
endmodule

module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Directly implement NOR with single-level assign to minimize delay, area and power
    assign out = ~(in1 | in2);
endmodule