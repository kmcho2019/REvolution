module TopModule(
    input  a,
    input  b,
    output out
);

assign out = a == b;

// Alternatively, using basic gates
// assign out = ~(a ^ b);

endmodule