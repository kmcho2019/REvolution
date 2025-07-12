module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Directly implementing the Karnaugh map's logic with a simple OR operation
// This logic captures the condition where 'out' is 1 whenever any of 'a', 'b', or 'c' is 1
assign out = a | b | c;

endmodule