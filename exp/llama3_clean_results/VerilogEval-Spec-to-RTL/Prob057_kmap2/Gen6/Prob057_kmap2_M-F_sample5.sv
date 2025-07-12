module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*)
    out = (!c &&!d && b) || 
          (!c && d && (!a || b)) || 
          (c &&!d && (a || b)) || 
          (c && d && a && b) || 
          (!c &&!d &&!a && b) || 
          (!c && d && a &&!b);

endmodule