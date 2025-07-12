module TopModule (
    input [2:0] sel,
    input [3:0] data0, data1, data2, data3, data4, data5,
    output [3:0] out
);

assign out = (sel == 3'd0) ? data0 :
             (sel == 3'd1) ? data1 :
             (sel == 3'd2) ? data2 :
             (sel == 3'd3) ? data3 :
             (sel == 3'd4) ? data4 :
             (sel == 3'd5) ? data5 :
             4'b0;

endmodule