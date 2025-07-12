// Define a BitComparator module
module BitComparator(
    input  a,
    input  [4:0] vec,
    output [4:0] out
);

    assign out[0] = (a == vec[0]);
    assign out[1] = (a == vec[1]);
    assign out[2] = (a == vec[2]);
    assign out[3] = (a == vec[3]);
    assign out[4] = (a == vec[4]);

endmodule

// TopModule utilizing the BitComparator modules
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] vec = {a, b, c, d, e};
    wire [4:0] out_a, out_b, out_c, out_d, out_e;

    BitComparator cmp_a(a, vec, out_a);
    BitComparator cmp_b(b, vec, out_b);
    BitComparator cmp_c(c, vec, out_c);
    BitComparator cmp_d(d, vec, out_d);
    BitComparator cmp_e(e, vec, out_e);

    assign out[24:20] = out_a;
    assign out[19:15] = out_b;
    assign out[14:10] = out_c;
    assign out[9:5] = out_d;
    assign out[4:0] = out_e;

endmodule