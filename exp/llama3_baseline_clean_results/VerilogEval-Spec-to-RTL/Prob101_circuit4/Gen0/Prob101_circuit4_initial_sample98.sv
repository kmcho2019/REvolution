module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

assign q = (a == 0) ? (b || c || d) : (b || c);

endmodule