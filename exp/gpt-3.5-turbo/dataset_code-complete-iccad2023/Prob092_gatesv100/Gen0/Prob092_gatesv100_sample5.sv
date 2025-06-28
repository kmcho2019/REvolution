module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);

  integer i;

  // Calculation for out_both
  always @* begin
    for (i = 0; i < 99; i = i + 1) begin
      out_both[i] = (in[i] & in[i+1]);
    end
  end

  // Calculation for out_any
  always @* begin
    out_any[99] = in[0] | in[99]; // Wrap around for in[0]
    for (i = 1; i < 99; i = i + 1) begin
      out_any[i] = (in[i] | in[i-1]);
    end
  end

  // Calculation for out_different
  always @* begin
    for (i = 0; i < 99; i = i + 1) begin
      out_different[i] = (in[i] ^ in[i+1]);
    end
    out_different[99] = (in[99] ^ in[0]); // Wrap around for in[0]
  end

endmodule