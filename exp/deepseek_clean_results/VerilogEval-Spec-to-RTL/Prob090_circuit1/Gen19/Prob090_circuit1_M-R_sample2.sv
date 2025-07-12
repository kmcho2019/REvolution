module TopModule (
    input a,
    input b,
    output q
);
    assign q = a & b;  // Continuous assignment for combinational AND
endmodule