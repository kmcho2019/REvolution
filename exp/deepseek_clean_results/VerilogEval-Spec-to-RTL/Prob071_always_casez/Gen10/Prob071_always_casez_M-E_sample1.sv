module TopModule (
    input [7:0] in,
    output [2:0] pos
);

// Step 1: Create mask with only the first set bit remaining
wire [7:0] masked = in & (~in + 1);

// Step 2: Convert one-hot to binary position
wire [2:0] binary_pos;
assign binary_pos[2] = |masked[7:4];
assign binary_pos[1] = masked[3] | masked[2] | masked[7] | masked[6];
assign binary_pos[0] = masked[1] | masked[3] | masked[5] | masked[7];

// Step 3: Handle all-zero case
assign pos = (|in) ? binary_pos : 3'b000;

endmodule