module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Directly implementing the Karnaugh map's logic with a simple OR operation
assign out = a | b | c;

endmodule