module TopModule (
    input  a,
    input  b,
    output out
);
    // Directly assign the NOR of a and b to out using the bitwise NOR operator
    assign out = ~(a | b);
endmodule