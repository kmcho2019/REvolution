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

// Create one-hot encoded selection signals
wire [5:0] sel_onehot = (sel < 6) ? (6'b1 << sel) : 6'b0;

// Bitwise AND each data input with its selection bit
wire [3:0] selected0 = data0 & {4{sel_onehot[0]}};
wire [3:0] selected1 = data1 & {4{sel_onehot[1]}};
wire [3:0] selected2 = data2 & {4{sel_onehot[2]}};
wire [3:0] selected3 = data3 & {4{sel_onehot[3]}};
wire [3:0] selected4 = data4 & {4{sel_onehot[4]}};
wire [3:0] selected5 = data5 & {4{sel_onehot[5]}};

// OR all selected signals together
assign out = selected0 | selected1 | selected2 | selected3 | selected4 | selected5;

endmodule