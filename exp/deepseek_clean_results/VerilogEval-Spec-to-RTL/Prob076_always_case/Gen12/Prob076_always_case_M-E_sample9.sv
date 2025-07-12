module TopModule (
    input [2:0] sel,
    input [3:0] data0, data1, data2, data3, data4, data5,
    output [3:0] out
);

// Bit-sliced implementation
assign out[0] = (sel == 0) ? data0[0] :
                (sel == 1) ? data1[0] :
                (sel == 2) ? data2[0] :
                (sel == 3) ? data3[0] :
                (sel == 4) ? data4[0] :
                (sel == 5) ? data5[0] : 1'b0;

assign out[1] = (sel == 0) ? data0[1] :
                (sel == 1) ? data1[1] :
                (sel == 2) ? data2[1] :
                (sel == 3) ? data3[1] :
                (sel == 4) ? data4[1] :
                (sel == 5) ? data5[1] : 1'b0;

assign out[2] = (sel == 0) ? data0[2] :
                (sel == 1) ? data1[2] :
                (sel == 2) ? data2[2] :
                (sel == 3) ? data3[2] :
                (sel == 4) ? data4[2] :
                (sel == 5) ? data5[2] : 1'b0;

assign out[3] = (sel == 0) ? data0[3] :
                (sel == 1) ? data1[3] :
                (sel == 2) ? data2[3] :
                (sel == 3) ? data3[3] :
                (sel == 4) ? data4[3] :
                (sel == 5) ? data5[3] : 1'b0;

endmodule