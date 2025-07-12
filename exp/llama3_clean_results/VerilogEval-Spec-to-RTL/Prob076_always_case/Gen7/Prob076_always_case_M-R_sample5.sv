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

assign out = (sel < 6) ? ({data5, data4, data3, data2, data1, data0} >> (sel * 4))[3:0] : 4'b0;

endmodule