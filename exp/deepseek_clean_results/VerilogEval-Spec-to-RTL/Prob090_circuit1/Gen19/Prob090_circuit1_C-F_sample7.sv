module TopModule (
    input  a,
    input  b,
    output q
);
    // Combinational AND gate - q is 1 only when both inputs are 1
    assign q = a & b;
endmodule