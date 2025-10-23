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

wire [3:0] sel0, sel1, sel2, sel3, sel4, sel5;

assign sel0 = (sel == 3'b000)? data0 : 4'b0000;
assign sel1 = (sel == 3'b001)? data1 : 4'b0000;
assign sel2 = (sel == 3'b010)? data2 : 4'b0000;
assign sel3 = (sel == 3'b011)? data3 : 4'b0000;
assign sel4 = (sel == 3'b100)? data4 : 4'b0000;
assign sel5 = (sel == 3'b101)? data5 : 4'b0000;

assign out = sel0 | sel1 | sel2 | sel3 | sel4 | sel5;

endmodule