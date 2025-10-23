module TopModule (
    input  a, b, c, d,
    output q
);
    // Implement q = b | c using DeMorgan's equivalent
    wire nor_out;
    assign nor_out = ~(b | c);
    assign q = ~nor_out;
endmodule