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
assign sel_onehot = (sel <= 3'd5) ? (6'b1 << sel) : 6'b0;

assign out = ({4{sel_onehot[0]}} & data0) |
             ({4{sel_onehot[1]}} & data1) |
             ({4{sel_onehot[2]}} & data2) |
             ({4{sel_onehot[3]}} & data3) |
             ({4{sel_onehot[4]}} & data4) |
             ({4{sel_onehot[5]}} & data5);

endmodule