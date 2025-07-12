module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Generate comparison results in parallel
    wire a_min = (a <= b) & (a <= c) & (a <= d);
    wire b_min = (b <= a) & (b <= c) & (b <= d);
    wire c_min = (c <= a) & (c <= b) & (c <= d);
    wire d_min = (d <= a) & (d <= b) & (d <= c);

    // Priority encoder (select first valid minimum)
    assign min = a_min ? a :
                 b_min ? b :
                 c_min ? c :
                 d;

endmodule