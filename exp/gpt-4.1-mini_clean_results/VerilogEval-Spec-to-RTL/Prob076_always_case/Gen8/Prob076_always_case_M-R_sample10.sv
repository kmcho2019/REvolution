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

// Concatenate all data inputs into a single 24-bit vector, each 4 bits wide.
// Use sel to select the corresponding 4-bit chunk if sel is within range, else zero.
wire [23:0] all_data = {data5, data4, data3, data2, data1, data0};

assign out = (sel <= 3'd5) ? all_data[sel*4 +: 4] : 4'b0000;

endmodule