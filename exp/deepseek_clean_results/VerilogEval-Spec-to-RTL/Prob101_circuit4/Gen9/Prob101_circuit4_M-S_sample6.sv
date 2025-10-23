module TopModule (
    input b,
    input c,
    output q
);

    assign q = b | c;

endmodule