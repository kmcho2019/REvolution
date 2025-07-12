module NorGate #(
    parameter WIDTH = 1
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] y
);
    // Direct assign implementing NOR to optimize PPA and reuse
    assign y = ~(a | b);
endmodule

module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Instantiate the parameterized NorGate with width=1
    NorGate #(.WIDTH(1)) u_nor (
        .a(in1),
        .b(in2),
        .y(out)
    );
endmodule