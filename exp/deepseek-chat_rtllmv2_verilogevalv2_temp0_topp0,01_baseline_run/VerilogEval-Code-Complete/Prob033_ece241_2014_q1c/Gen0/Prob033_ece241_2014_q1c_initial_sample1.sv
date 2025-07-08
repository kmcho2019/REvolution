module TopModule (
  input [7:0] a,
  input [7:0] b,
  output [7:0] s,
  output overflow
);
  wire [7:0] sum;
  assign sum = a + b;
  assign s = sum;
  
  assign overflow = (~a[7] & ~b[7] & sum[7]) |  // Both positive, result negative
                   (a[7] & b[7] & ~sum[7]);    // Both negative, result positive
endmodule