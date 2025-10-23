module TopModule(
    input  a,
    input  b,
    output out
);

assign out = (a && b) || (!a && !b);

// Alternative implementation using XOR and NOT operators
// assign out = !(a ^ b);

endmodule