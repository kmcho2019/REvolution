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

// Generate selection masks for each input
wire [3:0] mask0 = {4{(sel == 3'd0)}};
wire [3:0] mask1 = {4{(sel == 3'd1)}};
wire [3:0] mask2 = {4{(sel == 3'd2)}};
wire [3:0] mask3 = {4{(sel == 3'd3)}};
wire [3:0] mask4 = {4{(sel == 3'd4)}};
wire [3:0] mask5 = {4{(sel == 3'd5)}};

// Compute output by masking and combining all inputs
assign out = (data0 & mask0) |
             (data1 & mask1) |
             (data2 & mask2) |
             (data3 & mask3) |
             (data4 & mask4) |
             (data5 & mask5);

endmodule