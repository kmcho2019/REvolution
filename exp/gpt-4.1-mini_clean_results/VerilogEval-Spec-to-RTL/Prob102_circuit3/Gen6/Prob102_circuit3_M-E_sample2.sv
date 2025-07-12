module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire na_b = ~(a | b);  // NOR gate on (a,b)
    wire nc_d = ~(c | d);  // NOR gate on (c,d)
    assign q = ~(na_b | nc_d);  // NAND gate on na_b and nc_d

endmodule