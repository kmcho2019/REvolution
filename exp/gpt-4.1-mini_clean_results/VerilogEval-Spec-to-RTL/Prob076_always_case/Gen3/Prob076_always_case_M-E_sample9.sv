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

// Concatenate all data inputs into a single 24-bit vector:
// data0 in bits [3:0], data1 in [7:4], ..., data5 in [23:20]
wire [23:0] all_data = {data5, data4, data3, data2, data1, data0};

// If sel <= 5, select the 4 bits starting at sel*4; otherwise output 0.
assign out = (sel <= 3'd5) ? all_data >> (sel * 4) : 24'b0;
assign out = (sel <= 3'd5) ? all_data[(sel*4) +: 4] : 4'b0000;

endmodule