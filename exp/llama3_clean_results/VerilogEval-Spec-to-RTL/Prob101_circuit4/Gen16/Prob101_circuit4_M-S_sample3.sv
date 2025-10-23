module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,  // This input is not used in the logic
    output q
);

assign q = a || b || c;

endmodule