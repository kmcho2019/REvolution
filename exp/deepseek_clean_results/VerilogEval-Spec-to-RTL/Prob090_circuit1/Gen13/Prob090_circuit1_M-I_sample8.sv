module TopModule (
    input  a,
    input  b,
    output q
);
    // Clear AND operation using bitwise AND
    assign q = a & b;
endmodule