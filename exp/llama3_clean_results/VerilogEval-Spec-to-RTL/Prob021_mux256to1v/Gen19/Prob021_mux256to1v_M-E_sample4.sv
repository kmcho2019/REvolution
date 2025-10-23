module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Divide the 1024-bit input vector into 16 groups of 64 bits each
wire [63:0] group [15:0];
genvar i;
for (i = 0; i < 16; i++) begin
    assign group[i] = in[(i * 64) +: 64];
end

// Use the upper 4 bits of the selector to select one of the 16 groups
wire [3:0] group_sel;
assign group_sel = sel[7:4];

// Use the lower 4 bits of the selector to select one of the 16 4-bit values within the chosen group
wire [3:0] value_sel;
assign value_sel = sel[3:0];

// Select the correct group based on the group selector
wire [63:0] selected_group;
always @(*) begin
    case (group_sel)
        4'd0: selected_group = group[0];
        4'd1: selected_group = group[1];
        4'd2: selected_group = group[2];
        4'd3: selected_group = group[3];
        4'd4: selected_group = group[4];
        4'd5: selected_group = group[5];
        4'd6: selected_group = group[6];
        4'd7: selected_group = group[7];
        4'd8: selected_group = group[8];
        4'd9: selected_group = group[9];
        4'd10: selected_group = group[10];
        4'd11: selected_group = group[11];
        4'd12: selected_group = group[12];
        4'd13: selected_group = group[13];
        4'd14: selected_group = group[14];
        4'd15: selected_group = group[15];
        default: selected_group = 64'd0;
    endcase
end

// Select the correct 4-bit value within the chosen group based on the value selector
assign out = selected_group[(value_sel * 4) +: 4];

endmodule