module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire ab_mux_out;
    wire cd_mux_out;

    assign ab_mux_out = (a & ~b) | (b & ~a) | (a & b);
    assign cd_mux_out = (c & ~d) | (d & ~c) | (c & d);

    assign q = ab_mux_out & cd_mux_out;

endmodule