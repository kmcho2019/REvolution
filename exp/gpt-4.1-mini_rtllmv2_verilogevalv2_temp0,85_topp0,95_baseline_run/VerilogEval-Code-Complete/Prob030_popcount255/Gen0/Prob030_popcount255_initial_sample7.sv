module TopModule (
  input [254:0] in,
  output reg [7:0] out
);
  // Use a generate block to sum bits in groups, reducing progressively
  // First, sum each bit into a 1-bit value (each bit is already 0 or 1)
  // Then sum groups of bits up to the full width

  // We'll do a multi-level addition tree:

  // Level 1: sum pairs of bits (127 sums + 1 leftover)
  wire [1:0] sum_level1 [0:126];
  genvar i;
  generate
    for (i=0; i<127; i=i+1) begin : level1
      assign sum_level1[i] = {1'b0, in[2*i]} + {1'b0, in[2*i+1]};
    end
  endgenerate
  wire [1:0] sum_level1_last = {1'b0, in[254]};

  // Level 2: sum pairs of 2-bit values from level 1
  // 63 pairs + 1 leftover
  wire [2:0] sum_level2 [0:62];
  generate
    for (i=0; i<63; i=i+1) begin : level2
      assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
    end
  endgenerate
  wire [2:0] sum_level2_last = {1'b0, sum_level1[126]} + {2'b00, sum_level1_last};

  // Level 3: sum pairs of 3-bit values from level 2
  // 31 pairs + 1 leftover
  wire [3:0] sum_level3 [0:30];
  generate
    for (i=0; i<31; i=i+1) begin : level3
      assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
    end
  endgenerate
  wire [3:0] sum_level3_last = sum_level2[62] + sum_level2_last;

  // Level 4: sum pairs of 4-bit values from level 3
  // 15 pairs + 1 leftover
  wire [4:0] sum_level4 [0:14];
  generate
    for (i=0; i<15; i=i+1) begin : level4
      assign sum_level4[i] = sum_level3[2*i] + sum_level3[2*i+1];
    end
  endgenerate
  wire [4:0] sum_level4_last = sum_level3[30] + sum_level3_last;

  // Level 5: sum pairs of 5-bit values from level 4
  // 7 pairs + 1 leftover
  wire [5:0] sum_level5 [0:6];
  generate
    for (i=0; i<7; i=i+1) begin : level5
      assign sum_level5[i] = sum_level4[2*i] + sum_level4[2*i+1];
    end
  endgenerate
  wire [5:0] sum_level5_last = sum_level4[14] + sum_level4_last;

  // Level 6: sum pairs of 6-bit values from level 5
  // 3 pairs + 1 leftover
  wire [6:0] sum_level6 [0:2];
  generate
    for (i=0; i<3; i=i+1) begin : level6
      assign sum_level6[i] = sum_level5[2*i] + sum_level5[2*i+1];
    end
  endgenerate
  wire [6:0] sum_level6_last = sum_level5[6] + sum_level5_last;

  // Level 7: sum pairs of 7-bit values from level 6
  // 1 pair + 1 leftover
  wire [7:0] sum_level7_0 = sum_level6[0] + sum_level6[1];
  wire [7:0] sum_level7_last = sum_level6[2] + sum_level6_last;

  // Final sum: sum two 8-bit values
  always @(*) begin
    out = sum_level7_0 + sum_level7_last;
  end

endmodule