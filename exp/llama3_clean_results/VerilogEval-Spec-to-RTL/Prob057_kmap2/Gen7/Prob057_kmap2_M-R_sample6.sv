module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (a && d) || 
             (!a && !b && (!c || d)) || 
             (!a && b && !d) || 
             (b && c);

endmodule