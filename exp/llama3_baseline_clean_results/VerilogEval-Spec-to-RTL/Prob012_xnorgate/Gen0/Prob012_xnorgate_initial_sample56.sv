module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a ^ b); // Using XOR (^) and NOT (~) operators

// Alternatively, you can also implement it directly with basic logic:
// assign out = (a && b) || (!a && !b);

endmodule