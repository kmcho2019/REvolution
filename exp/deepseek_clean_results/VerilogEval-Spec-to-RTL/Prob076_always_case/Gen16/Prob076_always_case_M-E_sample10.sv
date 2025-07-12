module TopModule (
    input [2:0] sel,
    input [3:0] data0, data1, data2, data3, data4, data5,
    output [3:0] out
);

// Selection masks
wire sel0 = (sel == 3'd0);
wire sel1 = (sel == 3'd1);
wire sel2 = (sel == 3'd2);
wire sel3 = (sel == 3'd3);
wire sel4 = (sel == 3'd4);
wire sel5 = (sel == 3'd5);

// Bitwise masked data
wire [3:0] masked0 = {4{sel0}} & data0;
wire [3:0] masked1 = {4{sel1}} & data1;
wire [3:0] masked2 = {4{sel2}} & data2;
wire [3:0] masked3 = {4{sel3}} & data3;
wire [3:0] masked4 = {4{sel4}} & data4;
wire [3:0] masked5 = {4{sel5}} & data5;

// Combine all masked data
assign out = masked0 | masked1 | masked2 | masked3 | masked4 | masked5;

endmodule