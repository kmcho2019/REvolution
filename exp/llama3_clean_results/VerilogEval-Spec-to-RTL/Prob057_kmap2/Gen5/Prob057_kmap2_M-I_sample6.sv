module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*)
    out = (!a && (!c || d)) || 
          (b && (!d || (a && c)));

endmodule