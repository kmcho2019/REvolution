module TopModule (
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output [3:0] out
);

wire [5:0] sel_onehot;

// Decode sel into one-hot only if sel in 0..5, else zero
assign sel_onehot[0] = (sel == 3'd0);
assign sel_onehot[1] = (sel == 3'd1);
assign sel_onehot[2] = (sel == 3'd2);
assign sel_onehot[3] = (sel == 3'd3);
assign sel_onehot[4] = (sel == 3'd4);
assign sel_onehot[5] = (sel == 3'd5);

// AND each data input with corresponding one-hot bit extended to 4 bits
wire [3:0] masked0 = data0 & {4{sel_onehot[0]}};
wire [3:0] masked1 = data1 & {4{sel_onehot[1]}};
wire [3:0] masked2 = data2 & {4{sel_onehot[2]}};
wire [3:0] masked3 = data3 & {4{sel_onehot[3]}};
wire [3:0] masked4 = data4 & {4{sel_onehot[4]}};
wire [3:0] masked5 = data5 & {4{sel_onehot[5]}};

// OR all masked signals for final output
assign out = masked0 | masked1 | masked2 | masked3 | masked4 | masked5;

endmodule