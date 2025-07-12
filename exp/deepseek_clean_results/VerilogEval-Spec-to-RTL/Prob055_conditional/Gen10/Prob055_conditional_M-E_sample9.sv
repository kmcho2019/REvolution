module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Comparison flags - each is 1 if the corresponding input is <= all others
    wire a_min = (a <= b) & (a <= c) & (a <= d);
    wire b_min = (b <= a) & (b <= c) & (b <= d);
    wire c_min = (c <= a) & (c <= b) & (c <= d);
    wire d_min = (d <= a) & (d <= b) & (d <= c);

    // Priority-encoded multiplexer (priority given to first true condition)
    assign min = a_min ? a :
                 b_min ? b :
                 c_min ? c :
                 d;

endmodule