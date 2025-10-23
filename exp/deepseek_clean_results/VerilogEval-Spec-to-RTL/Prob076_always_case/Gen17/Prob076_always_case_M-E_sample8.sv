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

// Generate 6-bit mask based on sel (one-hot encoding)
wire [5:0] mask = (sel == 3'b000) ? 6'b000001 :
                  (sel == 3'b001) ? 6'b000010 :
                  (sel == 3'b010) ? 6'b000100 :
                  (sel == 3'b011) ? 6'b001000 :
                  (sel == 3'b100) ? 6'b010000 :
                  (sel == 3'b101) ? 6'b100000 :
                  6'b000000;  // For sel >= 6

// Replicate each mask bit to 4 bits for bitwise AND with data inputs
wire [3:0] mask0 = {4{mask[0]}};
wire [3:0] mask1 = {4{mask[1]}};
wire [3:0] mask2 = {4{mask[2]}};
wire [3:0] mask3 = {4{mask[3]}};
wire [3:0] mask4 = {4{mask[4]}};
wire [3:0] mask5 = {4{mask[5]}};

// Bitwise AND each data input with its mask
wire [3:0] selected0 = data0 & mask0;
wire [3:0] selected1 = data1 & mask1;
wire [3:0] selected2 = data2 & mask2;
wire [3:0] selected3 = data3 & mask3;
wire [3:0] selected4 = data4 & mask4;
wire [3:0] selected5 = data5 & mask5;

// OR all selected inputs to get final output
assign out = selected0 | selected1 | selected2 | selected3 | selected4 | selected5;

endmodule