module TopModule(
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output reg [3:0] out
);

reg [3:0] data_array [0:5];

always @(sel or data0 or data1 or data2 or data3 or data4 or data5) begin
    data_array[0] = data0;
    data_array[1] = data1;
    data_array[2] = data2;
    data_array[3] = data3;
    data_array[4] = data4;
    data_array[5] = data5;
    
    out = (sel >= 3'b110)? 4'b0000 : data_array[sel];
end

endmodule