module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Define parameters for the input vector size, number of groups, and group size
localparam INPUT_SIZE = 1024;
localparam NUM_GROUPS = 16;
localparam GROUP_SIZE = 64;

// Split the input vector into 16 groups of 64 bits
wire [GROUP_SIZE-1:0] group_out [NUM_GROUPS-1:0];
genvar i;
for (i = 0; i < NUM_GROUPS; i++) begin
    assign group_out[i] = in[(i * GROUP_SIZE) +: GROUP_SIZE];
end

// Split each group into 16 blocks of 4 bits
wire [3:0] mem_block [NUM_GROUPS-1:0][15:0];
for (i = 0; i < NUM_GROUPS; i++) begin
    for (genvar j = 0; j < 16; j++) begin
        assign mem_block[i][j] = group_out[i][(j * 4) +: 4];
    end
end

// Use the 8-bit selector to directly select the correct memory block
assign out = mem_block[sel[7:4]][sel[3:0]];

endmodule