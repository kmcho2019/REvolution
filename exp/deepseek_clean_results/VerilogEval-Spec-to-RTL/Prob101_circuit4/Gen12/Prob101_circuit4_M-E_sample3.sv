module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Implement threshold detector: q=1 when {a,b,c,d} >= 2 (binary '10')
    // This is equivalent to: (a&b) | (a&c) | (a&d) | (b&c) | (b&d) | (c&d)
    // But implemented as arithmetic comparison for novelty
    wire [3:0] input_bus = {a, b, c, d};
    assign q = (input_bus >= 4'b0010);
endmodule