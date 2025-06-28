module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);

  // Calculate out_both
  assign out_both[0] = (in[0] & in[1]);
  genvar i;
  generate
    for (i = 1; i < 99; i = i + 1) begin
      assign out_both[i] = (in[i] & in[i+1]);
    end
  endgenerate

  // Calculate out_any
  assign out_any[99] = (in[99] | in[0]);
  genvar j;
  generate
    for (j = 0; j < 99; j = j + 1) begin
      assign out_any[j] = (in[j] | in[j+1]);
    end
  endgenerate

  // Calculate out_different
  assign out_different[0] = (in[0] != in[99]);
  genvar k;
  generate
    for (k = 1; k < 100; k = k + 1) begin
      assign out_different[k-1] = (in[k] != in[k-1]);
    end
  endgenerate

endmodule