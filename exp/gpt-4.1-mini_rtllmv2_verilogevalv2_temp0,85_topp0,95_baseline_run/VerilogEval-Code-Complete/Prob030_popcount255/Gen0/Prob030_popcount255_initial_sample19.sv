module TopModule (
  input [254:0] in,
  output reg [7:0] out
);

  integer i;
  reg [7:0] partial_counts [0:31]; // 31 full 8-bit chunks + 1 chunk with 7 bits
  reg [7:0] sum;

  // Function to count bits in up to 8-bit input
  function [7:0] popcount8;
    input [7:0] val;
    integer j;
    begin
      popcount8 = 0;
      for (j = 0; j < 8; j = j + 1)
        popcount8 = popcount8 + val[j];
    end
  endfunction

  always @(*) begin
    // Count each full 8-bit chunk
    for (i = 0; i < 31; i = i + 1) begin
      partial_counts[i] = popcount8(in[i*8 +: 8]);
    end
    // Handle last 7 bits separately
    partial_counts[31] = 0;
    for (i = 248; i < 255; i = i + 1) begin
      partial_counts[31] = partial_counts[31] + in[i];
    end

    // Sum all partial counts
    sum = 0;
    for (i = 0; i < 32; i = i + 1) begin
      sum = sum + partial_counts[i];
    end

    out = sum;
  end

endmodule