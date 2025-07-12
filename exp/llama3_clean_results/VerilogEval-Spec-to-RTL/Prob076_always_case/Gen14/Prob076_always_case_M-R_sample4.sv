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

wire [3:0] sel_data0 = (sel == 3'b000)? data0 : 4'd0;
wire [3:0] sel_data1 = (sel == 3'b001)? data1 : 4'd0;
wire [3:0] sel_data2 = (sel == 3'b010)? data2 : 4'd0;
wire [3:0] sel_data3 = (sel == 3'b011)? data3 : 4'd0;
wire [3:0] sel_data4 = (sel == 3'b100)? data4 : 4'd0;
wire [3:0] sel_data5 = (sel == 3'b101)? data5 : 4'd0;

assign out = sel_data0 | sel_data1 | sel_data2 | sel_data3 | sel_data4 | sel_data5;

endmodule