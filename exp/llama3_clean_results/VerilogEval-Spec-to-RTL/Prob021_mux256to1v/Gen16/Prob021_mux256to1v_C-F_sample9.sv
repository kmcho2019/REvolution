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
wire [GROUP_SIZE-1:0] selected_group;
assign selected_group = group_out[sel[7:4]];

// Use a case statement to select the 4-bit output
always @(*) begin
    case (sel[3:0])
        4'd0: out = selected_group[3:0];
        4'd1: out = selected_group[7:4];
        4'd2: out = selected_group[11:8];
        4'd3: out = selected_group[15:12];
        4'd4: out = selected_group[19:16];
        4'd5: out = selected_group[23:20];
        4'd6: out = selected_group[27:24];
        4'd7: out = selected_group[31:28];
        4'd8: out = selected_group[35:32];
        4'd9: out = selected_group[39:36];
        4'd10: out = selected_group[43:40];
        4'd11: out = selected_group[47:44];
        4'd12: out = selected_group[51:48];
        4'd13: out = selected_group[55:52];
        4'd14: out = selected_group[59:56];
        4'd15: out = selected_group[63:60];
        default: out = 4'd0;
    endcase
end

endmodule