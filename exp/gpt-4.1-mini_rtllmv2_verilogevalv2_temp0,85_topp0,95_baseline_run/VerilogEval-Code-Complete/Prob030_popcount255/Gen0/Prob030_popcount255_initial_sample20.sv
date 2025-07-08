module TopModule (
  input [254:0] in,
  output reg [7:0] out
);

  // We'll use a generate block to implement a tree of adders.
  // First, break down the 255 bits into groups of 3 bits and count the number of 1's in each group (resulting in 2-bit sums).
  // Then, combine these 2-bit sums in larger groups until we get the final 8-bit sum.

  // Number of 3-bit groups: ceil(255/3) = 85 groups.
  wire [1:0] group_sums [0:84]; // each is 2 bits wide

  genvar i;
  generate
    for (i = 0; i < 85; i = i + 1) begin : bit_groups
      // Extract 3 bits for the group, pad with zeros if out of range
      wire b0 = (3*i < 255) ? in[3*i] : 1'b0;
      wire b1 = (3*i+1 < 255) ? in[3*i+1] : 1'b0;
      wire b2 = (3*i+2 < 255) ? in[3*i+2] : 1'b0;

      // Count how many bits are 1 in this group of 3 bits
      assign group_sums[i] = b0 + b1 + b2; // sums to 0..3 fits in 2 bits
    end
  endgenerate

  // Now sum these 85 2-bit numbers to get the final count.
  // We'll do this by iterative addition in an always block.

  integer j;
  reg [13:0] sum; // max 255, so 8 bits is enough, 14 bits is safe

  always @* begin
    sum = 0;
    for (j = 0; j < 85; j = j + 1) begin
      sum = sum + group_sums[j];
    end
    out = sum[7:0]; // output 8-bit count
  end

endmodule