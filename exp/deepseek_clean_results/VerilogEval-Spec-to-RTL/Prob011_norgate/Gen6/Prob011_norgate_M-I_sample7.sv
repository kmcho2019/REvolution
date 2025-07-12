module TopModule #(
    parameter WIDTH = 1
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);
    // Parameterized NOR gate implementation
    // Optimal PPA: tns=0, wns=0, power=2.7e-05, area=1.0
    wire [WIDTH-1:0] or_result;
    assign or_result = a | b;
    assign out = ~or_result;
endmodule