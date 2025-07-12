module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

// Use a direct logic implementation based on the Karnaugh map
always @(a, b, c, d) begin
    out = (~a & ~c & ~d) | 
          (~a & b & ~c) | 
          (~a & ~b & d) | 
          (~c & ~d & a) | 
          (b & ~c & d) | 
          (a & b & c);
end

endmodule