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

// Generate one-hot encoded selection signals with invalid selection handling
wire [5:0] sel_onehot = (sel < 3'd6) ? (6'b1 << sel) : 6'b0;

// Mask each data input with its corresponding selection bit
wire [3:0] masked0 = data0 & {4{sel_onehot[0]}};
wire [3:0] masked1 = data1 & {4{sel_onehot[1]}};
wire [3:0] masked2 = data2 & {4{sel_onehot[2]}};
wire [3:0] masked3 = data3 & {4{sel_onehot[3]}};
wire [3:0] masked4 = data4 & {4{sel_onehot[4]}};
wire [3:0] masked5 = data5 & {4{sel_onehot[5]}};

// Combine all masked inputs
assign out = masked0 | masked1 | masked2 | masked3 | masked4 | masked5;

endmodule