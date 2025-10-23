module TopModule(
    input a,
    input b,
    input c,
    output out
);

assign out = a || (!a && (b || c));

// Alternatively, simplifying it to:
// assign out = a || (b || c);

endmodule