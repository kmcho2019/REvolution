module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    // q is simply the OR of b and c
    assign q = b | c;
endmodule