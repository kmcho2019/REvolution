module TopModule(
    input  a,
    input  b,
    input  c,
    output wire out
);

// Karnaugh map shows output = 1 for all inputs except a=0,b=0,c=0.
// Minimal logic: out = a OR b OR c.
assign out = a | b | c;

endmodule