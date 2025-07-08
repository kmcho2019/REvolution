module TopModule (
  input [254:0] in,
  output reg [7:0] out
);

// Function to count number of 1's in an input vector of arbitrary width (up to 8)
function [3:0] popcount8;
  input [7:0] data;
  integer i;
  begin
    popcount8 = 0;
    for (i=0; i<8; i=i+1)
      popcount8 = popcount8 + data[i];
  end
endfunction

integer i;
reg [7:0] partial_counts [31:0];
reg [7:0] sum;

always @(*) begin
  // Initialize partial counts to zero
  for (i=0; i<32; i=i+1)
    partial_counts[i] = 0;

  // Handle first 31 chunks of 8 bits
  for (i=0; i<31; i=i+1) begin
    partial_counts[i] = popcount8(in[i*8 +: 8]);
  end

  // Last chunk has only 255 - 31*8 = 255 - 248 = 7 bits (actually 7 bits)
  // But the input vector is 255 bits, so bits 248 to 254 inclusive (7 bits)
  partial_counts[31] = 0;
  for (integer j=0; j<7; j=j+1) begin
    partial_counts[31] = partial_counts[31] + in[248 + j];
  end

  // Sum all partial counts
  sum = 0;
  for (i=0; i<32; i=i+1)
    sum = sum + partial_counts[i];

  out = sum;
end

endmodule