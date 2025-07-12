module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Define parameters for the input vector size, number of groups, and group size
localparam INPUT_SIZE = 1024;
localparam NUM_GROUPS = 16;
localparam GROUP_SIZE = 64;

// First stage: Select one of 16 groups of 64 bits
wire [GROUP_SIZE-1:0] group_out [NUM_GROUPS-1:0];
genvar i;
for (i = 0; i < NUM_GROUPS; i++) begin
    assign group_out[i] = in[(i * GROUP_SIZE) +: GROUP_SIZE];
end

// Second stage: Select one of 16 possible 4-bit inputs from the chosen group
assign out = group_out[sel[7:4]][(sel[3:0] * 4) +: 4];

endmodule