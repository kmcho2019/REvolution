module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    wire [7:0] ab_min;
    assign ab_min = (a < b) ? a : b;
    wire [7:0] abc_min;
    assign abc_min = (ab_min < c) ? ab_min : c;
    assign min = (abc_min < d) ? abc_min : d;

endmodule