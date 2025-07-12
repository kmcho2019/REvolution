module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // For each bit, determine if A > B or A < B at that bit
    wire [3:0] bit_gt = (A & ~B);
    wire [3:0] bit_lt = (~A & B);

    // Generate one-bit signals indicating at that bit A > B or A < B (only when bits differ)
    wire [3:0] bit_diff = bit_gt | bit_lt;

    // Priority from MSB to LSB: find the highest bit where A and B differ
    // Using combinational priority logic for 4 bits
    wire gt_bit, lt_bit;

    // If bit 3 differ, decide result by that bit
    wire msb_gt = bit_gt[3];
    wire msb_lt = bit_lt[3];

    // If not bit3 differ, check bit2
    wire bit2_gt = bit_gt[2] & ~bit_diff[3];
    wire bit2_lt = bit_lt[2] & ~bit_diff[3];

    // If not bits 3 or 2 differ, check bit1
    wire bit1_gt = bit_gt[1] & ~bit_diff[3] & ~bit_diff[2];
    wire bit1_lt = bit_lt[1] & ~bit_diff[3] & ~bit_diff[2];

    // If not bits 3,2,1 differ, check bit0
    wire bit0_gt = bit_gt[0] & ~bit_diff[3] & ~bit_diff[2] & ~bit_diff[1];
    wire bit0_lt = bit_lt[0] & ~bit_diff[3] & ~bit_diff[2] & ~bit_diff[1];

    // Combine all gt signals
    assign gt_bit = msb_gt | bit2_gt | bit1_gt | bit0_gt;
    // Combine all lt signals
    assign lt_bit = msb_lt | bit2_lt | bit1_lt | bit0_lt;

    // If no bit differs, then A == B
    wire equal = ~(|bit_diff);

    // Outputs mutually exclusive by construction
    assign A_greater = gt_bit;
    assign A_less    = lt_bit;
    assign A_equal   = equal;

endmodule