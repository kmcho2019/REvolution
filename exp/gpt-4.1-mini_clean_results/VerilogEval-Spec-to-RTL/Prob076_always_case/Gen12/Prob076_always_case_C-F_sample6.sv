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

// Aggregate inputs into a packed array for indexed access
wire [3:0] data_array [0:5];
assign data_array[0] = data0;
assign data_array[1] = data1;
assign data_array[2] = data2;
assign data_array[3] = data3;
assign data_array[4] = data4;
assign data_array[5] = data5;

// Output logic: if sel in [0..5], output corresponding data; else zero
assign out = (sel < 3'd6) ? data_array[sel] : 4'b0000;

endmodule