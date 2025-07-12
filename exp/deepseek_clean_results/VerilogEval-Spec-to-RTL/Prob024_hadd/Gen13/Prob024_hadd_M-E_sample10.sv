module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // MUX-based implementation
    assign sum = b ? ~a : a;  // When b=1, invert a; when b=0, pass a
    assign cout = a & b;      // Carry is just the AND of inputs
endmodule