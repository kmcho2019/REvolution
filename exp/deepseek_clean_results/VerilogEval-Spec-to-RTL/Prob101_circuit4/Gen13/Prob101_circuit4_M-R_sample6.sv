module TopModule (
    input  a, b, c, d,
    output q
);
    // q is b OR c (a and d are unused inputs)
    wire b_or_c;
    assign b_or_c = b | c;
    assign q = b_or_c;
endmodule