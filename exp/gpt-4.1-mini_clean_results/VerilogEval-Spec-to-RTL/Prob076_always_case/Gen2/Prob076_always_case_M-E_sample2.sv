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

    // Pack inputs into an array for indexed access
    wire [3:0] data_arr [0:5];
    assign data_arr[0] = data0;
    assign data_arr[1] = data1;
    assign data_arr[2] = data2;
    assign data_arr[3] = data3;
    assign data_arr[4] = data4;
    assign data_arr[5] = data5;

    // Output 0 if sel > 5, else select data from array
    assign out = (sel < 6) ? data_arr[sel] : 4'b0000;

endmodule