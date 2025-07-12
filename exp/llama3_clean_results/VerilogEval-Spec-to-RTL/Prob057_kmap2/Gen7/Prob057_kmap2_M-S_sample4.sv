module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*) 
begin
    out = (!c && !d && b) || 
          (!c && d && a && b) || 
          (c && !d && (!a && !b || a && b)) || 
          (c && d && (a && b || a && !b || !a && b));
end

endmodule