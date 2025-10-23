module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*)
begin
    out = (a && b) || 
          (!a &&!c &&!d) || 
          (!a &&!b && c) || 
          (a &&!b &&!c);
end

endmodule