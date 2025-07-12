module TopModule(
    input  [254:0] in,
    output [7:0] out
);

// First, divide the input into chunks of 15 bits
wire [15:0] chunk0;
wire [15:0] chunk1;
wire [15:0] chunk2;
wire [15:0] chunk3;
wire [15:0] chunk4;
wire [15:0] chunk5;
wire [15:0] chunk6;
wire [15:0] chunk7;
wire [15:0] chunk8;
wire [15:0] chunk9;
wire [15:0] chunk10;
wire [15:0] chunk11;
wire [15:0] chunk12;
wire [15:0] chunk13;
wire [15:0] chunk14;
wire [15:0] chunk15;
wire [15:0] chunk16;

assign chunk0  = {in[254:240],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk1  = {in[239:225],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk2  = {in[224:210],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk3  = {in[209:195],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk4  = {in[194:180],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk5  = {in[179:165],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk6  = {in[164:150],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk7  = {in[149:135],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk8  = {in[134:120],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk9  = {in[119:105],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk10 = {in[104: 90],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk11 = {in[ 89: 75],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk12 = {in[ 74: 60],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk13 = {in[ 59: 45],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk14 = {in[ 44: 30],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk15 = {in[ 29: 15],  1'b0, 1'b0, 1'b0, 1'b0};
assign chunk16 = {in[ 14:  0],  1'b0, 1'b0, 1'b0, 1'b0};

// Count the number of '1's in each chunk
wire [3:0] count0;
wire [3:0] count1;
wire [3:0] count2;
wire [3:0] count3;
wire [3:0] count4;
wire [3:0] count5;
wire [3:0] count6;
wire [3:0] count7;
wire [3:0] count8;
wire [3:0] count9;
wire [3:0] count10;
wire [3:0] count11;
wire [3:0] count12;
wire [3:0] count13;
wire [3:0] count14;
wire [3:0] count15;
wire [3:0] count16;

// Use a combinational circuit to count the number of '1's in each chunk
PopCount15 popcount0 (.in(chunk0),  .out(count0));
PopCount15 popcount1 (.in(chunk1),  .out(count1));
PopCount15 popcount2 (.in(chunk2),  .out(count2));
PopCount15 popcount3 (.in(chunk3),  .out(count3));
PopCount15 popcount4 (.in(chunk4),  .out(count4));
PopCount15 popcount5 (.in(chunk5),  .out(count5));
PopCount15 popcount6 (.in(chunk6),  .out(count6));
PopCount15 popcount7 (.in(chunk7),  .out(count7));
PopCount15 popcount8 (.in(chunk8),  .out(count8));
PopCount15 popcount9 (.in(chunk9),  .out(count9));
PopCount15 popcount10 (.in(chunk10), .out(count10));
PopCount15 popcount11 (.in(chunk11), .out(count11));
PopCount15 popcount12 (.in(chunk12), .out(count12));
PopCount15 popcount13 (.in(chunk13), .out(count13));
PopCount15 popcount14 (.in(chunk14), .out(count14));
PopCount15 popcount15 (.in(chunk15), .out(count15));
PopCount15 popcount16 (.in(chunk16), .out(count16));

// Add up the counts to get the final result
wire [7:0] sum;

// Add up the counts in a tree-like fashion
wire [7:0] sum0;
wire [7:0] sum1;
wire [7:0] sum2;
wire [7:0] sum3;
wire [7:0] sum4;
wire [7:0] sum5;
wire [7:0] sum6;
wire [7:0] sum7;

assign sum0 = count0 + count1;
assign sum1 = count2 + count3;
assign sum2 = count4 + count5;
assign sum3 = count6 + count7;
assign sum4 = count8 + count9;
assign sum5 = count10 + count11;
assign sum6 = count12 + count13;
assign sum7 = count14 + count15;

wire [7:0] sum8;
wire [7:0] sum9;
wire [7:0] sum10;
wire [7:0] sum11;

assign sum8 = sum0 + sum1;
assign sum9 = sum2 + sum3;
assign sum10 = sum4 + sum5;
assign sum11 = sum6 + sum7;

wire [7:0] sum12;
wire [7:0] sum13;

assign sum12 = sum8 + sum9;
assign sum13 = sum10 + sum11;

wire [7:0] sum14;

assign sum14 = sum12 + sum13;

assign sum = sum14 + count16;

// Final result
assign out = sum;

endmodule

module PopCount15(
    input  [15:0] in,
    output [3:0] out
);

reg [3:0] out;

always @*
begin
    out = 4'd0;
    for (int i = 0; i < 16; i = i + 1)
    begin
        if (in[i] == 1'b1)
        begin
            out = out + 1;
        end
    end
end

endmodule