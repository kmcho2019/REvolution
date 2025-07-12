module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Combined first and second layer operations
    assign out = (a & b) | (c & d);
    assign out_n = ~out;

endmodule