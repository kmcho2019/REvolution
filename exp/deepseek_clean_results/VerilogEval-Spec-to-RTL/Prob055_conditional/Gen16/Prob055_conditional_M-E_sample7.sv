module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Generate is_min signals for each input
    wire a_is_min = (a <= b) & (a <= c) & (a <= d);
    wire b_is_min = (b <  a) & (b <= c) & (b <= d);
    wire c_is_min = (c <  a) & (c <  b) & (c <= d);
    wire d_is_min = (d <  a) & (d <  b) & (d <  c);

    // Select minimum using priority encoding
    assign min = a_is_min ? a :
                b_is_min ? b :
                c_is_min ? c :
                d;

endmodule