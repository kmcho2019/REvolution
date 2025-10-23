module TopModule (
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output [3:0] out
);

// Generate one-hot mask
wire [5:0] mask = (sel < 6) ? (6'b1 << sel) : 6'b0;

// Bitwise selection and combination
assign out = ({4{mask[0]}} & data0) |
              ({4{mask[1]}} & data1) |
              ({4{mask[2]}} & data2) |
              ({4{mask[3]}} & data3) |
              ({4{mask[4]}} & data4) |
              ({4{mask[5]}} & data5);

endmodule