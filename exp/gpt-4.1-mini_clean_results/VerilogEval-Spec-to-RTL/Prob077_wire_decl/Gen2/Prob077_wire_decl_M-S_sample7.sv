module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    wire or_in;

    assign or_in = (a & b) | (c & d);
    assign out = or_in;
    assign out_n = ~out;

endmodule