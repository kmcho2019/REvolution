module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);

  // Output vector indicating whether both input bit and its left neighbor are '1'
  always @*
  begin
    for (int i=0; i<99; i=i+1)
    begin
      out_both[i] = (in[i] & in[i+1]);
    end
  end

  // Output vector indicating if any of the input bit or its right neighbor is '1'
  always @*
  begin
    out_any[99] = in[99]; // For the last bit
    for (int i=1; i<100; i=i+1)
    begin
      out_any[i] = (in[i] | in[i-1]);
    end
  end

  // Output vector indicating whether the input bit is different from its left neighbor
  always @*
  begin
    for (int i=0; i<99; i=i+1)
    begin
      out_different[i] = (in[i] ^ in[i+1]);
    end
    out_different[99] = (in[99] ^ in[0]); // Treat as wrapping around
  end

endmodule