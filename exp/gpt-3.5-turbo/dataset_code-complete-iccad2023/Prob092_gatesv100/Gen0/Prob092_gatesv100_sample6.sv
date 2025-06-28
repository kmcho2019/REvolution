module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);

  integer i;
  
  // Logic for out_both
  always @* begin 
    for (i = 0; i < 99; i = i + 1) begin
      if (in[i] & in[i+1])
        out_both[i] = 1;
      else
        out_both[i] = 0;
    end
  end
  
  // Logic for out_any
  always @* begin 
    for (i = 1; i < 100; i = i + 1) begin
      if (in[i] | in[i-1])
        out_any[i] = 1;
      else
        out_any[i] = 0;
    end
  end
  
  // Logic for out_different
  always @* begin 
    for (i = 0; i < 99; i = i + 1) begin
      if (in[i] != in[i+1])
        out_different[i] = 1;
      else
        out_different[i] = 0;
    end
    if (in[99] != in[0])
      out_different[99] = 1;
    else
      out_different[99] = 0;
  end

endmodule