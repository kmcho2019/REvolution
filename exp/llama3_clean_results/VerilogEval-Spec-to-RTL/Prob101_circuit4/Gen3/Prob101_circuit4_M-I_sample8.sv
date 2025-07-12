module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

// Final output q is high when b or c is high, or when a is low
assign q = (b || c) || !a;

endmodule