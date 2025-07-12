module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    wire [7:0] sel_a = {8{sel}} & a;
    wire [7:0] sel_b = {8{~sel}} & b;
    assign out = sel_a | sel_b;

endmodule