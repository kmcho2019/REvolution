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

// Decoded signals for each selection
wire dec0, dec1, dec2, dec3, dec4, dec5;

// Decoder for the sel signal
assign dec0 = (sel == 3'b000);
assign dec1 = (sel == 3'b001);
assign dec2 = (sel == 3'b010);
assign dec3 = (sel == 3'b011);
assign dec4 = (sel == 3'b100);
assign dec5 = (sel == 3'b101);

// AND gates for each data input with its corresponding decoded signal
wire [3:0] and0, and1, and2, and3, and4, and5;
assign and0 = data0 & {4{dec0}};
assign and1 = data1 & {4{dec1}};
assign and2 = data2 & {4{dec2}};
assign and3 = data3 & {4{dec3}};
assign and4 = data4 & {4{dec4}};
assign and5 = data5 & {4{dec5}};

// OR the outputs of the AND gates to get the final output
assign out = and0 | and1 | and2 | and3 | and4 | and5;

endmodule