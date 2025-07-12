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

// Simplified enable - true when sel <= 5 (sel[2]&(sel[1]|sel[0]) would be >5)
wire enable = ~(sel[2] & (sel[1] | sel[0]));

// Continuous assignment with conditional operator
assign out = enable ? 
             (sel == 0) ? data0 :
             (sel == 1) ? data1 :
             (sel == 2) ? data2 :
             (sel == 3) ? data3 :
             (sel == 4) ? data4 :
             (sel == 5) ? data5 : 4'b0
           : 4'b0;

endmodule