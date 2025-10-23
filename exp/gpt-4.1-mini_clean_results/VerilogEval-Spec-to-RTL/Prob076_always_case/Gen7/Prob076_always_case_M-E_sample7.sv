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

wire [23:0] all_data;
assign all_data = {data5, data4, data3, data2, data1, data0};

wire sel_valid = (sel <= 3'd5);
wire [4:0] shift_amt = sel * 4;

wire [23:0] shifted_data = all_data >> shift_amt;
assign out = sel_valid ? shifted_data[3:0] : 4'b0000;

endmodule