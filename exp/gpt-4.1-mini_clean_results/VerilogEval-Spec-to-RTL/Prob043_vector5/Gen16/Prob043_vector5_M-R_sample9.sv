module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_vec = {a, b, c, d, e};

    // Create 25 bits by comparing all pairs in nested generate loop fashion,
    // but here we build them explicitly in a wire vector, then assign concatenated result.

    wire [24:0] compare_bits;

    assign compare_bits = {
        (in_vec[4]  ^~ in_vec[4]),  (in_vec[4]  ^~ in_vec[3]),  (in_vec[4]  ^~ in_vec[2]),  (in_vec[4]  ^~ in_vec[1]),  (in_vec[4]  ^~ in_vec[0]),
        (in_vec[3]  ^~ in_vec[4]),  (in_vec[3]  ^~ in_vec[3]),  (in_vec[3]  ^~ in_vec[2]),  (in_vec[3]  ^~ in_vec[1]),  (in_vec[3]  ^~ in_vec[0]),
        (in_vec[2]  ^~ in_vec[4]),  (in_vec[2]  ^~ in_vec[3]),  (in_vec[2]  ^~ in_vec[2]),  (in_vec[2]  ^~ in_vec[1]),  (in_vec[2]  ^~ in_vec[0]),
        (in_vec[1]  ^~ in_vec[4]),  (in_vec[1]  ^~ in_vec[3]),  (in_vec[1]  ^~ in_vec[2]),  (in_vec[1]  ^~ in_vec[1]),  (in_vec[1]  ^~ in_vec[0]),
        (in_vec[0]  ^~ in_vec[4]),  (in_vec[0]  ^~ in_vec[3]),  (in_vec[0]  ^~ in_vec[2]),  (in_vec[0]  ^~ in_vec[1]),  (in_vec[0]  ^~ in_vec[0])
    };

    // Assign the output accordingly; the above matches out[24:0]
    assign out = compare_bits;

endmodule