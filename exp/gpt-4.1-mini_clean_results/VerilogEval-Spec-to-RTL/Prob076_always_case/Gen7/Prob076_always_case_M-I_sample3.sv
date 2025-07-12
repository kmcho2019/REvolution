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

wire [3:0] mux_array [5:0];

assign mux_array[0] = data0;
assign mux_array[1] = data1;
assign mux_array[2] = data2;
assign mux_array[3] = data3;
assign mux_array[4] = data4;
assign mux_array[5] = data5;

assign out = (sel < 6) ? mux_array[sel] : 4'b0000;

endmodule