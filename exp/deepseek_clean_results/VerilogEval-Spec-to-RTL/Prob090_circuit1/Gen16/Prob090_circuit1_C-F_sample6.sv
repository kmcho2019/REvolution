module TopModule (
    input  a,
    input  b,
    output q
);
    assign q = a & b;  // Pure combinational AND gate
endmodule