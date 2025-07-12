// Novel array-based implementation of the module
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

reg [3:0] data_array [5:0];

always @(*) begin
    // Initialize the array with the input data
    data_array[0] = data0;
    data_array[1] = data1;
    data_array[2] = data2;
    data_array[3] = data3;
    data_array[4] = data4;
    data_array[5] = data5;

    // Use the select signal to index the array
    if (sel >= 0 && sel <= 5) begin
        out = data_array[sel];
    end else begin
        out = 4'b0; // Default condition
    end
end

endmodule