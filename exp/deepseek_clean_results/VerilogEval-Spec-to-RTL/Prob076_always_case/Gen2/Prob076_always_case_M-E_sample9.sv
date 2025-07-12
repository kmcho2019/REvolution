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
wire [3:0] selected [5:0];

// Generate one-hot encoded selection signals
assign sel_one_hot[0] = (sel == 3'b000);
assign sel_one_hot[1] = (sel == 3'b001);
assign sel_one_hot[2] = (sel == 3'b010);
assign sel_one_hot[3] = (sel == 3'b011);
assign sel_one_hot[4] = (sel == 3'b100);
assign sel_one_hot[5] = (sel == 3'b101);

// Bitwise AND between data and selection signals
assign selected[0] = {4{sel_one_hot[0]}} & data0;
assign selected[1] = {4{sel_one_hot[1]}} & data1;
assign selected[2] = {4{sel_one_hot[2]}} & data2;
assign selected[3] = {4{sel_one_hot[3]}} & data3;
assign selected[4] = {4{sel_one_hot[4]}} & data4;
assign selected[5] = {4{sel_one_hot[5]}} & data5;

// Combine all selected signals with OR
assign out = selected[0] | selected[1] | selected[2] | 
             selected[3] | selected[4] | selected[5];

endmodule