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

wire [5:0] sel_onehot = {
    sel == 3'b101,  // sel=5
    sel == 3'b100,  // sel=4
    sel == 3'b011,  // sel=3
    sel == 3'b010,  // sel=2
    sel == 3'b001,  // sel=1
    sel == 3'b000   // sel=0
};

assign out = ({4{sel_onehot[0]}} & data0) |
             ({4{sel_onehot[1]}} & data1) |
             ({4{sel_onehot[2]}} & data2) |
             ({4{sel_onehot[3]}} & data3) |
             ({4{sel_onehot[4]}} & data4) |
             ({4{sel_onehot[5]}} & data5);

endmodule