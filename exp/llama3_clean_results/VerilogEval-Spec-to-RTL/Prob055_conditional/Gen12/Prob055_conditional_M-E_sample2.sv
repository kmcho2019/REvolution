module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    wire is_a_min = (a <= b) && (a <= c) && (a <= d);
    wire is_b_min = (b <= a) && (b <= c) && (b <= d);
    wire is_c_min = (c <= a) && (c <= b) && (c <= d);
    wire is_d_min = (d <= a) && (d <= b) && (d <= c);

    assign min = (is_a_min) ? a :
                (is_b_min) ? b :
                (is_c_min) ? c :
                (is_d_min) ? d : 8'b0;

endmodule