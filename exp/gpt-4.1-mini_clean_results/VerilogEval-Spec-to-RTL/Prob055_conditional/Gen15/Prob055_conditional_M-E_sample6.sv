module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);
    wire a_is_min, b_is_min, c_is_min, d_is_min;

    // Check if each input is less than or equal to all others
    assign a_is_min = (a <= b) && (a <= c) && (a <= d);
    assign b_is_min = (b <= a) && (b <= c) && (b <= d);
    assign c_is_min = (c <= a) && (c <= b) && (c <= d);
    assign d_is_min = (d <= a) && (d <= b) && (d <= c);

    // Since min is unique, one of these will be true; select the min input accordingly
    // Priority given by order a, b, c, d in case of ties to ensure a defined output
    assign min = a_is_min ? a :
                 b_is_min ? b :
                 c_is_min ? c :
                 d;

endmodule