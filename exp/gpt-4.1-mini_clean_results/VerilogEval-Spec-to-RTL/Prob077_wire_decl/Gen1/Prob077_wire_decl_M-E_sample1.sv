module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    wire or1_out;
    wire or2_out;

    assign or1_out = a | c;
    assign or2_out = b | d;

    assign out = or1_out & or2_out;
    assign out_n = ~out;

endmodule