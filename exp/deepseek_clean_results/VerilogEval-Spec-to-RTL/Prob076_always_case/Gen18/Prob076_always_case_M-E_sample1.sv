module TopModule (
    input [2:0] sel,
    input [3:0] data0, data1, data2, data3, data4, data5,
    output [3:0] out
);

// Pack all data inputs into a single array
wire [3:0] data_array [0:5];
assign data_array[0] = data0;
assign data_array[1] = data1;
assign data_array[2] = data2;
assign data_array[3] = data3;
assign data_array[4] = data4;
assign data_array[5] = data5;

// Select output based on sel value
assign out = (sel < 6) ? data_array[sel] : 4'b0;

endmodule