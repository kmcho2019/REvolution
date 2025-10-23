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

wire sel_valid = (sel <= 3'd5);  // Valid when sel is 0-5
wire [5:0] sel_onehot = {
    (sel == 3'd5) & sel_valid,
    (sel == 3'd4) & sel_valid,
    (sel == 3'd3) & sel_valid,
    (sel == 3'd2) & sel_valid,
    (sel == 3'd1) & sel_valid,
    (sel == 3'd0) & sel_valid
};

assign out = ({4{sel_onehot[0]}} & data0) |
             ({4{sel_onehot[1]}} & data1) |
             ({4{sel_onehot[2]}} & data2) |
             ({4{sel_onehot[3]}} & data3) |
             ({4{sel_onehot[4]}} & data4) |
             ({4{sel_onehot[5]}} & data5);

endmodule