module TopModule(
    input  a,
    input  b,
    output q
);

// Direct implementation of an AND gate
assign q = a & b;

endmodule