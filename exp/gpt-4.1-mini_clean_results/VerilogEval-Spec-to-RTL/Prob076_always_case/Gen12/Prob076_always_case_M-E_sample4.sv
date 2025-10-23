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

    // Concatenate all data inputs from data5 down to data0 plus 4'b0000 for out-of-range sel
    wire [27:0] concat_data = {data5, data4, data3, data2, data1, data0, 4'b0000};

    // Select a 4-bit slice starting at sel*4 bits
    assign out = concat_data[sel*4 +: 4];

endmodule