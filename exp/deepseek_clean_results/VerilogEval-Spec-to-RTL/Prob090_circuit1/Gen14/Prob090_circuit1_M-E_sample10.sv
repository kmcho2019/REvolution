module TopModule (
    input  a,
    input  b,
    output q
);
    // Implement AND using a 2:1 MUX
    // When both a and b are 1, select 1, otherwise select 0
    assign q = (a & b) ? 1'b1 : 1'b0;
endmodule