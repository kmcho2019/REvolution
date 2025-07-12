module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (c == 0 && d == 0 && (a || b)) || 
             (c && !d && b) || 
             (a && b && !d) || 
             (a && b && c);

endmodule