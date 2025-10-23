module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Directly assign the result of the OR operation between b and c to q
assign q = b || c;

endmodule