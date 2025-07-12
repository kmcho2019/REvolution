module TopModule(
    input  a,
    input  b,
    input  c,
    output reg out
);

// Karnaugh map shows output = 1 for all inputs except a=0,b=0,c=0.
// Minimal logic: out = a OR b OR c.

always @(*) begin
    out = a | b | c;
end

endmodule