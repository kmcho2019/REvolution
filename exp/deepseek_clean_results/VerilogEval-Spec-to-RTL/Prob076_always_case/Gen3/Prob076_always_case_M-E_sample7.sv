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

// Generate selection masks
wire [3:0] mask0 = {4{sel == 3'b000}};
wire [3:0] mask1 = {4{sel == 3'b001}};
wire [3:0] mask2 = {4{sel == 3'b010}};
wire [3:0] mask3 = {4{sel == 3'b011}};
wire [3:0] mask4 = {4{sel == 3'b100}};
wire [3:0] mask5 = {4{sel == 3'b101}};

// Apply masks and combine results
assign out = (data0 & mask0) |
             (data1 & mask1) |
             (data2 & mask2) |
             (data3 & mask3) |
             (data4 & mask4) |
             (data5 & mask5);

endmodule