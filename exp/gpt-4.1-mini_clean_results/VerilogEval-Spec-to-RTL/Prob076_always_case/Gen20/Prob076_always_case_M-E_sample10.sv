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

    // Concatenate all inputs into a 24-bit vector: {data5, ..., data0}
    wire [23:0] all_data = {data5, data4, data3, data2, data1, data0};

    // If sel is in range 0 to 5, shift right by sel*4 bits, then take the lowest 4 bits as output
    // Else output 0
    assign out = (sel <= 3'd5) ? (all_data >> (sel * 4)) [3:0] : 4'b0000;

endmodule