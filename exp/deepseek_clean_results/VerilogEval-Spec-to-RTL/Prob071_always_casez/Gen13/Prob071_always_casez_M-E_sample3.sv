module TopModule (
    input [7:0] in,
    output [2:0] pos
);

// Level 1: Individual bit positions
wire bit0 = in[0];
wire bit1 = in[1] & ~bit0;
wire bit2 = in[2] & ~(|in[1:0]);
wire bit3 = in[3] & ~(|in[2:0]);
wire bit4 = in[4] & ~(|in[3:0]);
wire bit5 = in[5] & ~(|in[4:0]);
wire bit6 = in[6] & ~(|in[5:0]);
wire bit7 = in[7] & ~(|in[6:0]);

// Level 2: Combine into 4 groups (2 bits each)
wire [1:0] group0 = {bit1, bit0};
wire [1:0] group1 = {bit3, bit2};
wire [1:0] group2 = {bit5, bit4};
wire [1:0] group3 = {bit7, bit6};

// Level 3: Combine into 2 groups (4 bits each)
wire [3:0] half0 = {group1, group0};
wire [3:0] half1 = {group3, group2};

// Final output selection
assign pos[0] = |{half0[0], half0[2], half1[0], half1[2]};
assign pos[1] = |{half0[2], half0[3], half1[2], half1[3]};
assign pos[2] = |half1;

endmodule