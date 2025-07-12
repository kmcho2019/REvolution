module TopModule (
    input  a, b, c, d,
    output q
);

    wire b_or_c;
    wire a_and_not_d;
    
    assign b_or_c = b | c;
    assign a_and_not_d = a & ~d;
    assign q = b_or_c & ~a_and_not_d;

endmodule