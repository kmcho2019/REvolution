module TopModule(
    input a,
    input b,
    input c,
    output out
);

// The Karnaugh map directly translates to an OR operation for the inputs
assign out = a | b | c;

endmodule