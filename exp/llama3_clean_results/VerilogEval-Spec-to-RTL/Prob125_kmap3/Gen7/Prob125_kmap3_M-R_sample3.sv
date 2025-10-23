module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = a ? 1'b1 : (b ? (c ? 1'b1 : 1'b0) : (c ? 1'b1 : 1'b0));

// Alternatively, simplifying the conditional statement further
// assign out = a || (!b && c);

endmodule