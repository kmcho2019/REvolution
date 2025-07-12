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

    wire [23:0] data_pack;
    assign data_pack = {data5, data4, data3, data2, data1, data0};

    // Select index range starting bit = sel * 4, but only valid if sel < 6
    wire valid_sel = (sel < 3'd6);

    // Extract corresponding 4-bit slice if valid_sel, else zero
    assign out = valid_sel ? data_pack[sel*4 +: 4] : 4'b0000;

endmodule