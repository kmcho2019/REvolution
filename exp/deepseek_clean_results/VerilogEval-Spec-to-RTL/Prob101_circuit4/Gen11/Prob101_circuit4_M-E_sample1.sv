module TopModule (
    input  a, b, c, d,
    output q
);
    assign q = c ? 1'b1 : b;
endmodule