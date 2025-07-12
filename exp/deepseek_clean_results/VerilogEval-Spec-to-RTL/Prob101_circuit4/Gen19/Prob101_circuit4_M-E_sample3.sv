module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire special_case = a & ~d;
    wire normal_case = b | c;
    
    assign q = special_case ? 1'b0 : normal_case;

endmodule