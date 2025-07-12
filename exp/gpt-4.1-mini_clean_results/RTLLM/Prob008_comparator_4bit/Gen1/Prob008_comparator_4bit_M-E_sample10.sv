module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Compare each bit pair: generate greater and less signals per bit
    wire [3:0] A_gt_B_bit; // A[i] > B[i]
    wire [3:0] A_lt_B_bit; // A[i] < B[i]

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : bit_compare
            assign A_gt_B_bit[i] = A[i] & ~B[i];
            assign A_lt_B_bit[i] = ~A[i] & B[i];
        end
    endgenerate

    // From MSB to LSB, determine overall greater/less signals using priority logic
    wire greater_found;
    wire less_found;

    // Priority for greater: highest bit where A[i] > B[i] and no higher bit difference found
    wire greater_bit3 = A_gt_B_bit[3];
    wire greater_bit2 = ~A_gt_B_bit[3] & ~A_lt_B_bit[3] & A_gt_B_bit[2];
    wire greater_bit1 = ~A_gt_B_bit[3] & ~A_lt_B_bit[3] & ~A_gt_B_bit[2] & ~A_lt_B_bit[2] & A_gt_B_bit[1];
    wire greater_bit0 = ~A_gt_B_bit[3] & ~A_lt_B_bit[3] & ~A_gt_B_bit[2] & ~A_lt_B_bit[2] & ~A_gt_B_bit[1] & ~A_lt_B_bit[1] & A_gt_B_bit[0];

    assign greater_found = greater_bit3 | greater_bit2 | greater_bit1 | greater_bit0;

    // Priority for less: highest bit where A[i] < B[i] and no higher bit difference found
    wire less_bit3 = A_lt_B_bit[3];
    wire less_bit2 = ~A_gt_B_bit[3] & ~A_lt_B_bit[3] & A_lt_B_bit[2];
    wire less_bit1 = ~A_gt_B_bit[3] & ~A_lt_B_bit[3] & ~A_gt_B_bit[2] & ~A_lt_B_bit[2] & A_lt_B_bit[1];
    wire less_bit0 = ~A_gt_B_bit[3] & ~A_lt_B_bit[3] & ~A_gt_B_bit[2] & ~A_lt_B_bit[2] & ~A_gt_B_bit[1] & ~A_lt_B_bit[1] & A_lt_B_bit[0];

    assign less_found = less_bit3 | less_bit2 | less_bit1 | less_bit0;

    // If no greater or less found, A == B
    assign A_equal = ~(greater_found | less_found);
    assign A_greater = greater_found;
    assign A_less = less_found;

endmodule