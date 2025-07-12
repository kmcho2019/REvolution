module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Convert inputs to thermometer codes
wire [6:0] thermA = (1 << A) - 1;
wire [6:0] thermB = (1 << B) - 1;

// XOR mask to find first differing bit
wire [6:0] diff_mask = thermA ^ thermB;

// Find the highest bit where they differ (priority encoder)
wire diff_bit6 = diff_mask[6];
wire diff_bit5 = ~diff_mask[6] & diff_mask[5];
wire diff_bit4 = ~diff_mask[6] & ~diff_mask[5] & diff_mask[4];
wire diff_bit3 = ~diff_mask[6] & ~diff_mask[5] & ~diff_mask[4] & diff_mask[3];
wire diff_bit2 = ~diff_mask[6] & ~diff_mask[5] & ~diff_mask[4] & ~diff_mask[3] & diff_mask[2];
wire diff_bit1 = ~diff_mask[6] & ~diff_mask[5] & ~diff_mask[4] & ~diff_mask[3] & ~diff_mask[2] & diff_mask[1];
wire diff_bit0 = ~diff_mask[6] & ~diff_mask[5] & ~diff_mask[4] & ~diff_mask[3] & ~diff_mask[2] & ~diff_mask[1] & diff_mask[0];

// Determine comparison result at first differing bit
assign A_greater = diff_bit6 & thermA[6] |
                  diff_bit5 & thermA[5] |
                  diff_bit4 & thermA[4] |
                  diff_bit3 & thermA[3] |
                  diff_bit2 & thermA[2] |
                  diff_bit1 & thermA[1] |
                  diff_bit0 & thermA[0];

assign A_less = diff_bit6 & thermB[6] |
               diff_bit5 & thermB[5] |
               diff_bit4 & thermB[4] |
               diff_bit3 & thermB[3] |
               diff_bit2 & thermB[2] |
               diff_bit1 & thermB[1] |
               diff_bit0 & thermB[0];

assign A_equal = ~|diff_mask;  // No bits differ

endmodule