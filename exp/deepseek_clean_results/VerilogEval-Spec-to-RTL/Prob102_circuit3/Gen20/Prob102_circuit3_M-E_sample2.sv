module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire a_and_d;
    assign a_and_d = a & d;
    assign q = b | a_and_d;

endmodule