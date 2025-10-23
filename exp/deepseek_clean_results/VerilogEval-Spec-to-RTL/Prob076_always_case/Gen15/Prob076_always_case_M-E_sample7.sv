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

wire [5:0] sel_one_hot;
wire valid_sel;

// Create one-hot encoded selection with validity check
assign valid_sel = (sel <= 3'd5);
assign sel_one_hot = valid_sel ? (6'b1 << sel) : 6'b0;

// Bitwise selection of each data input
wire [3:0] selected_data [0:5];
assign selected_data[0] = {4{sel_one_hot[0]}} & data0;
assign selected_data[1] = {4{sel_one_hot[1]}} & data1;
assign selected_data[2] = {4{sel_one_hot[2]}} & data2;
assign selected_data[3] = {4{sel_one_hot[3]}} & data3;
assign selected_data[4] = {4{sel_one_hot[4]}} & data4;
assign selected_data[5] = {4{sel_one_hot[5]}} & data5;

// Combine all selected data
assign out = selected_data[0] | selected_data[1] | selected_data[2] | 
             selected_data[3] | selected_data[4] | selected_data[5];

endmodule