module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire or_out;
    assign or_out = b | c;
    assign q = or_out;

endmodule