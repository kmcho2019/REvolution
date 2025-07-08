module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);
  wire feedback = q[0] ^ q[21] ^ q[1] ^ q[31];
  integer i;

  always @(posedge clk) begin
    if (reset)
      q <= 32'h1;
    else begin
      // Shift right with Galois taps
      // For each bit position:
      // If tapped, next bit = current bit shifted right XOR feedback
      // Else next bit = current bit shifted right
      q[0] <= feedback;
      q[31] <= q[30] ^ feedback; // tap at bit 32 (q[31])
      q[21] <= q[20] ^ feedback; // tap at bit 22 (q[21])
      q[1]  <= q[0]  ^ feedback; // tap at bit 2 (q[1])
      
      // For other bits without taps, just shift right
      q[30:22] <= q[29:21];
      q[20:2]  <= q[19:1];
      q[19:2]  <= q[18:1]; // This duplicates previous line; must be careful
      q[20:2]  <= q[19:1]; // Correct slicing for bits without taps

      // Let's handle the bits without taps carefully:
      // bits without taps are all except 31,21,1,0
      // q[30:22] <= q[29:21]
      // q[20:2]  <= q[19:1]
      // q[0] and the tapped bits handled separately

      // But since q[1] and q[21] and q[31] handled separately, remove them from these slices
      // So let's assign bits [30:22] and [20:2] but exclude q[21] and q[1]
      // q[21] is assigned above, so q[22:30] = q[21:29]
      // q[2:20] = q[1:19], but q[1] is assigned above, so q[2:20] = q[1:19] but q[1] is a tap
      // To avoid overwrite, assign q[30:22] and q[20:2] excluding tapped bits carefully.

      // Let's write full assignment with a temporary variable to avoid race conditions
    end
  end
endmodule