module TopModule(
    input a,
    input b,
    input c,
    output out
);
    // Majority voting: out = (a&b) | (b&c) | (a&c)
    wire ab, bc, ac;
    assign ab = a & b;
    assign bc = b & c;
    assign ac = a & c;
    assign out = ab | bc | ac;
endmodule