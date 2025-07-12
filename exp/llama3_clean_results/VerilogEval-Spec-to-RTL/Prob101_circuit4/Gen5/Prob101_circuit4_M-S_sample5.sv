module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

assign q = b || c || (a && (b || c));

// Applying the simplification
assign q = b || c || a;

// Since (b || c) already covers the case when a is high and (b || c) is high, 
// the expression can be further reduced to:
assign q = b || c || a;

endmodule