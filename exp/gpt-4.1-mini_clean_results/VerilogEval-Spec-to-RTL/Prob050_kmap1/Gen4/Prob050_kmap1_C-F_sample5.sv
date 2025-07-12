module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

// Minimal logic from Karnaugh map: output is 1 for all inputs except a=0,b=0,c=0
// Thus, out = a OR b OR c

assign out = a | b | c;

endmodule