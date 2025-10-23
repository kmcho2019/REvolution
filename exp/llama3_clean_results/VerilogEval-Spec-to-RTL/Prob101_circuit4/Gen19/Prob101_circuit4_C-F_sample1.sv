module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Direct implementation of the required logic using a single OR operation
assign q = b | c;

endmodule