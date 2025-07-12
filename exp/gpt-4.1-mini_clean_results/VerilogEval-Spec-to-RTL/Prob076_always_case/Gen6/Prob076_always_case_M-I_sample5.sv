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

    // Concatenate inputs into an 24-bit vector: {data5, data4, data3, data2, data1, data0}
    wire [23:0] data_concat = {data5, data4, data3, data2, data1, data0};

    // If sel < 6, select corresponding 4-bit slice, else output zero
    assign out = (sel < 6) ? data_concat[sel*4 +: 4] : 4'b0000;

endmodule