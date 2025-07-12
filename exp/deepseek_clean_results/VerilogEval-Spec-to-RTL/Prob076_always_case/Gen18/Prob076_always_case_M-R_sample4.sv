module TopModule (
    input [2:0] sel,
    input [3:0] data0, data1, data2, data3, data4, data5,
    output [3:0] out
);

assign out = (sel == 0) ? data0 :
             (sel == 1) ? data1 :
             (sel == 2) ? data2 :
             (sel == 3) ? data3 :
             (sel == 4) ? data4 :
             (sel == 5) ? data5 : 4'b0;

endmodule