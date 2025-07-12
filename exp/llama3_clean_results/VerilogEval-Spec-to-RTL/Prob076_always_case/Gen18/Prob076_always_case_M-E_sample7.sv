module TopModule(
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output [3:0] out
);

wire [5:0] enable;
assign enable[0] = (sel == 3'b000);
assign enable[1] = (sel == 3'b001);
assign enable[2] = (sel == 3'b010);
assign enable[3] = (sel == 3'b011);
assign enable[4] = (sel == 3'b100);
assign enable[5] = (sel == 3'b101);

wire [3:0] data_out0 = enable[0] ? data0 : 4'b0000;
wire [3:0] data_out1 = enable[1] ? data1 : 4'b0000;
wire [3:0] data_out2 = enable[2] ? data2 : 4'b0000;
wire [3:0] data_out3 = enable[3] ? data3 : 4'b0000;
wire [3:0] data_out4 = enable[4] ? data4 : 4'b0000;
wire [3:0] data_out5 = enable[5] ? data5 : 4'b0000;

assign out[0] = data_out0[0] | data_out1[0] | data_out2[0] | data_out3[0] | data_out4[0] | data_out5[0];
assign out[1] = data_out0[1] | data_out1[1] | data_out2[1] | data_out3[1] | data_out4[1] | data_out5[1];
assign out[2] = data_out0[2] | data_out1[2] | data_out2[2] | data_out3[2] | data_out4[2] | data_out5[2];
assign out[3] = data_out0[3] | data_out1[3] | data_out2[3] | data_out3[3] | data_out4[3] | data_out5[3];

endmodule