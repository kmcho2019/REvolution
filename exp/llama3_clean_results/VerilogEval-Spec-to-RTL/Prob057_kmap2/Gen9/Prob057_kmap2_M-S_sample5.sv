module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (!c && !a) || 
             (!d && !a) || 
             (b && !c && !d) || 
             (b && d && a);

endmodule