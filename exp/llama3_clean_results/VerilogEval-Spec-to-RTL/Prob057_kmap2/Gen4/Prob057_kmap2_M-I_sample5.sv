module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*)
    out = (!c && (!a || b)) || 
          (d && (!a ||!b)) || 
          (c && (!a || b));

endmodule