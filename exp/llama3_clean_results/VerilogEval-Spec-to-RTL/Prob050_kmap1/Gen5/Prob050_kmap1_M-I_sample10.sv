module TopModule(
    input a,
    input b,
    input c,
    output out
);

// The direct assignment statement is sufficient for this simple logic operation
assign out = a | b | c;

endmodule