module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Simplified logic from the K-map: out = a + (b & c)
    assign out = a | (b & c);

endmodule