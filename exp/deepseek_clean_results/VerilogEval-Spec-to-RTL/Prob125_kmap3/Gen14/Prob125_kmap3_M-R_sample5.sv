module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Combined logic in single assignment:
    // When a=1: output 1
    // Else: output (c ? (a|~b) : a)
    assign out = a ? 1'b1 : (c ? (a | ~b) : a);
endmodule