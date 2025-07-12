module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    wire min_a = (a <= b) && (a <= c) && (a <= d);
    wire min_b = (b <= a) && (b <= c) && (b <= d);
    wire min_c = (c <= a) && (c <= b) && (c <= d);
    wire min_d = (d <= a) && (d <= b) && (d <= c);

    assign min = (min_a) ? a :
                (min_b) ? b :
                (min_c) ? c :
                d;

endmodule