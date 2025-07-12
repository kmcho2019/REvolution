module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*)
    out = (!a &&!b && (!c &&!d ||!c && d)) || 
          (!a && b &&!c &&!d) || 
          (a && b && c && d) || 
          (a &&!b && (!c &&!d ||!c && d));

endmodule