module TopModule (
    input  a, b, c, d,
    output q
);
    // q is b OR c (a and d are unused inputs)
    assign q = b | c;
endmodule