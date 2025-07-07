module TopModule (
  input [254:0] in,
  output reg [7:0] out
);

  // Function to count bits in an 8-bit vector
  function [3:0] popcount8;
    input [7:0] x;
    integer i;
    begin
      popcount8 = 0;
      for (i = 0; i < 8; i = i + 1)
        popcount8 = popcount8 + x[i];
    end
  endfunction

  integer i;
  reg [7:0] partial_counts [31:0]; // 32 chunks of 8 bits (last chunk only 7 bits used)
  reg [7:0] sum;

  always @(*) begin
    // Initialize partial counts
    for (i = 0; i < 31; i = i + 1) begin
      partial_counts[i] = popcount8(in[i*8 +: 8]);
    end
    // Last chunk is only 7 bits (bits 248 to 254)
    partial_counts[31] = popcount8({1'b0, in[254:248]}); // pad MSB with 0 to make 8 bits

    // Sum all partial counts
    sum = 0;
    for (i = 0; i < 32; i = i + 1) begin
      sum = sum + partial_counts[i];
    end

    out = sum;
  end

endmodule