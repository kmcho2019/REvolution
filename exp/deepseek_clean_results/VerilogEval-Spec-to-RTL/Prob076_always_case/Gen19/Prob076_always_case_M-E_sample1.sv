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

wire sel_valid = (sel <= 3'd5);  // Valid selection range
wire [5:0] sel_onehot = {sel == 3'd5, sel == 3'd4, sel == 3'd3, 
                         sel == 3'd2, sel == 3'd1, sel == 3'd0};

// Bit 0
assign out[0] = sel_valid & (
    (sel_onehot[0] & data0[0]) |
    (sel_onehot[1] & data1[0]) |
    (sel_onehot[2] & data2[0]) |
    (sel_onehot[3] & data3[0]) |
    (sel_onehot[4] & data4[0]) |
    (sel_onehot[5] & data5[0]));

// Bit 1
assign out[1] = sel_valid & (
    (sel_onehot[0] & data0[1]) |
    (sel_onehot[1] & data1[1]) |
    (sel_onehot[2] & data2[1]) |
    (sel_onehot[3] & data3[1]) |
    (sel_onehot[4] & data4[1]) |
    (sel_onehot[5] & data5[1]));

// Bit 2
assign out[2] = sel_valid & (
    (sel_onehot[0] & data0[2]) |
    (sel_onehot[1] & data1[2]) |
    (sel_onehot[2] & data2[2]) |
    (sel_onehot[3] & data3[2]) |
    (sel_onehot[4] & data4[2]) |
    (sel_onehot[5] & data5[2]));

// Bit 3
assign out[3] = sel_valid & (
    (sel_onehot[0] & data0[3]) |
    (sel_onehot[1] & data1[3]) |
    (sel_onehot[2] & data2[3]) |
    (sel_onehot[3] & data3[3]) |
    (sel_onehot[4] & data4[3]) |
    (sel_onehot[5] & data5[3]));

endmodule