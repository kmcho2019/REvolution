module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (!a && !c) || 
             (a && !b && !c) || 
             (b && !c && d) || 
             (a && b && c) || 
             (!a && b && !d);

endmodule