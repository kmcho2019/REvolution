module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out // Declare out as a reg type
);

// Use a direct logic implementation based on the Karnaugh map
always @(a, b, c, d) begin
    out = (a & ~b & ~c & ~d) | 
          (~a & b & ~c & ~d) | 
          (~a & ~b & c & ~d) | 
          (~a & ~b & ~c & d) | 
          (~a & b & c & ~d) | 
          (~a & b & ~c & d) | 
          (a & b & c & d) | 
          (a & ~b & c & d) | 
          (a & b & ~c & d);
end

endmodule