module TopModule(
    input a,
    input b,
    input c,
    input d,      // don't care input, ignored in logic
    output out
);
    // Implement the minimized expression from Karnaugh map:
    // out = ~b & c + a & c + a & b
    // Using bitwise operators:
    assign out = (~b & c) | (a & c) | (a & b);

endmodule