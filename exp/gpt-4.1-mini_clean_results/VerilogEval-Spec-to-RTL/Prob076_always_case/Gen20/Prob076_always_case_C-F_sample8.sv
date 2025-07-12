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

    // Pack inputs into an array for indexed selection
    wire [3:0] data_array [0:5];
    assign data_array[0] = data0;
    assign data_array[1] = data1;
    assign data_array[2] = data2;
    assign data_array[3] = data3;
    assign data_array[4] = data4;
    assign data_array[5] = data5;

    // Output zero if sel out of range, else select indexed input
    assign out = (sel <= 3'd5) ? data_array[sel] : 4'b0000;

endmodule