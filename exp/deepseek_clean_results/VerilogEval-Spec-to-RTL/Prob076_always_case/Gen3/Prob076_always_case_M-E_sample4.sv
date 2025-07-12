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

// Generate one-hot mask for each possible selection
wire [5:0] mask = (sel == 3'd0) ? 6'b000001 :
                 (sel == 3'd1) ? 6'b000010 :
                 (sel == 3'd2) ? 6'b000100 :
                 (sel == 3'd3) ? 6'b001000 :
                 (sel == 3'd4) ? 6'b010000 :
                 (sel == 3'd5) ? 6'b100000 : 6'b000000;

// Mask and combine all data inputs
assign out = ({4{mask[0]}} & data0) |
             ({4{mask[1]}} & data1) |
             ({4{mask[2]}} & data2) |
             ({4{mask[3]}} & data3) |
             ({4{mask[4]}} & data4) |
             ({4{mask[5]}} & data5);

endmodule