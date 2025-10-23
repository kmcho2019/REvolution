module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

assign q = (b && (c ||!c)) || (a && d) || (d && b) || (a && b && c);

// Alternatively, a more simplified version:
assign q = b || (a && d);

endmodule