module TopModule (
    input in1,
    input in2,
    output out
);
    wire or_out;
    or OR1 (or_out, in1, in2);
    not INV1 (out, or_out);
endmodule