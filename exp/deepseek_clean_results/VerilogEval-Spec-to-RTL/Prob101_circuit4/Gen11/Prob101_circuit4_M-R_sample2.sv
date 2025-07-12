module TopModule (
    input  a, b, c, d,
    output q
);
    // Direct implementation of q = b | c
    assign q = b | c;
endmodule