module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Combinational logic: q = b OR c
    assign q = b | c;
endmodule