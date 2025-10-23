module TopModule (
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output [3:0] out
);

// First 3-to-1 mux for sel[1:0] = 0,1,2
wire [3:0] mux_low;
assign mux_low = (sel[1:0] == 2'd0) ? data0 :
                 (sel[1:0] == 2'd1) ? data1 :
                 (sel[1:0] == 2'd2) ? data2 :
                 4'b0000;

// Second 3-to-1 mux for sel[1:0] = 0,1,2 but inputs data3,data4,data5
wire [3:0] mux_high;
assign mux_high = (sel[1:0] == 2'd0) ? data3 :
                  (sel[1:0] == 2'd1) ? data4 :
                  (sel[1:0] == 2'd2) ? data5 :
                  4'b0000;

// Top-level 2-to-1 mux selects between mux_low and mux_high by sel[2]
// If sel>5, output zero
assign out = (sel[2] == 1'b0 && sel[1:0] <= 2'd2) ? mux_low :
             (sel[2] == 1'b1 && sel[1:0] <= 2'd2) ? mux_high :
             4'b0000;

endmodule