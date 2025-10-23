module Decoder(
    input  [2:0] sel,
    output [5:0] enable
);

assign enable[0] = (sel == 3'b000)? 1'b1 : 1'b0;
assign enable[1] = (sel == 3'b001)? 1'b1 : 1'b0;
assign enable[2] = (sel == 3'b010)? 1'b1 : 1'b0;
assign enable[3] = (sel == 3'b011)? 1'b1 : 1'b0;
assign enable[4] = (sel == 3'b100)? 1'b1 : 1'b0;
assign enable[5] = (sel == 3'b101)? 1'b1 : 1'b0;

endmodule

module TopModule(
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output reg [3:0] out
);

Decoder dec(sel, enable);

wire [3:0] data_en0 = enable[0]? data0 : 4'b0000;
wire [3:0] data_en1 = enable[1]? data1 : 4'b0000;
wire [3:0] data_en2 = enable[2]? data2 : 4'b0000;
wire [3:0] data_en3 = enable[3]? data3 : 4'b0000;
wire [3:0] data_en4 = enable[4]? data4 : 4'b0000;
wire [3:0] data_en5 = enable[5]? data5 : 4'b0000;

assign out = data_en0 | data_en1 | data_en2 | data_en3 | data_en4 | data_en5;

endmodule