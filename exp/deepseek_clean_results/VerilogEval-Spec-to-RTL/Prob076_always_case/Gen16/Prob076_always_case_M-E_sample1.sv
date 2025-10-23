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

// First level muxes
wire [3:0] mux_low = (sel[1:0] == 2'd0) ? data0 :
                     (sel[1:0] == 2'd1) ? data1 :
                     (sel[1:0] == 2'd2) ? data2 : 4'b0;

wire [3:0] mux_high = (sel[1:0] == 2'd0) ? data3 :
                      (sel[1:0] == 2'd1) ? data4 :
                      (sel[1:0] == 2'd2) ? data5 : 4'b0;

// Second level mux
assign out = (sel[2] & (sel < 3'd6)) ? mux_high : 
             (~sel[2] & (sel < 3'd6)) ? mux_low : 4'b0;

endmodule