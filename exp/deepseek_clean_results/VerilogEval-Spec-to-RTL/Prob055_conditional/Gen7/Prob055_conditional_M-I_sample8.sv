module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    wire a_lt_b = (a < b);
    wire a_lt_c = (a < c);
    wire a_lt_d = (a < d);
    wire b_lt_c = (b < c);
    wire b_lt_d = (b < d);
    wire c_lt_d = (c < d);

    assign min = (~a_lt_b & ~a_lt_c & ~a_lt_d) ? a :
                 (a_lt_b & ~b_lt_c & ~b_lt_d) ? b :
                 (a_lt_c & b_lt_c & ~c_lt_d)  ? c :
                 d;

endmodule