module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Direct implementation of the Karnaugh map using an OR operation.
assign out = a | b | c;

endmodule