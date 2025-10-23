module TopModule (
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output [3:0] out
);

wire [5:0] sel_mask;
wire [3:0] selected [5:0];

// Create selection masks
assign sel_mask[0] = (sel == 3'd0);
assign sel_mask[1] = (sel == 3'd1);
assign sel_mask[2] = (sel == 3'd2);
assign sel_mask[3] = (sel == 3'd3);
assign sel_mask[4] = (sel == 3'd4);
assign sel_mask[5] = (sel == 3'd5);

// Mask each data input
assign selected[0] = {4{sel_mask[0]}} & data0;
assign selected[1] = {4{sel_mask[1]}} & data1;
assign selected[2] = {4{sel_mask[2]}} & data2;
assign selected[3] = {4{sel_mask[3]}} & data3;
assign selected[4] = {4{sel_mask[4]}} & data4;
assign selected[5] = {4{sel_mask[5]}} & data5;

// Combine all selected inputs
assign out = selected[0] | selected[1] | selected[2] |
             selected[3] | selected[4] | selected[5];

endmodule