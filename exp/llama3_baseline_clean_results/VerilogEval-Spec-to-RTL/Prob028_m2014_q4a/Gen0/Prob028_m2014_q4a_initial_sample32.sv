module TopModule(d, ena, q);
  input d;
  input ena;
  output reg q;

  always @(d or ena)
    if (ena)
      q <= d;
    else
      q <= q;
endmodule