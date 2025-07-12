module TopModule #(
    parameter WIDTH = 8
) (
    input              sel,
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);

    wire [WIDTH-1:0] sel_a = {WIDTH{~sel}} & a;
    wire [WIDTH-1:0] sel_b = {WIDTH{sel}} & b;
    assign out = sel_a | sel_b;

endmodule