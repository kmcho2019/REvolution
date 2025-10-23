module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Directly implementing the logic from the Karnaugh map
// 'out' is 1 if 'a' is 1 or if either 'b' or 'c' is 1
assign out = a | b | c;

endmodule