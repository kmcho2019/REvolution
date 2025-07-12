module TopModule(
    input  a,
    input  b,
    output out
);

assign out = a == b;

// Alternatively, a manual implementation could be:
// assign out = (a && b) || (!a && !b);

endmodule