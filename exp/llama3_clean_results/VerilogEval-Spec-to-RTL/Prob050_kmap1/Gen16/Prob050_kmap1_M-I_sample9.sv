module TopModule(
    input a,
    input b,
    input c,
    output out
);

// The logic can be simplified to 'out' being 1 if any of 'a', 'b', or 'c' is 1
// This directly follows from the Karnaugh map and minimizes the number of operations
assign out = a | b | c;

endmodule