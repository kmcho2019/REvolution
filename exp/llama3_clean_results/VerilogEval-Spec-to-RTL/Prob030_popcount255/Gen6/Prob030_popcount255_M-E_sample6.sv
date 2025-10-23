module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Define a 17-bit population count circuit
module popcount17(
    input [16:0] in,
    output [4:0] out
);
    reg [4:0] count;
    always @(in) begin
        count = 0;
        for (int i = 0; i < 17; i++) begin
            count = count + in[i];
        end
    end
    assign out = count;
endmodule

// Divide the 255-bit input into 15 chunks of 17 bits each
wire [16:0] chunk0, chunk1, chunk2, chunk3, chunk4, chunk5, chunk6, chunk7, chunk8, chunk9, chunk10, chunk11, chunk12, chunk13, chunk14;
assign chunk0  = in[16:0];
assign chunk1  = in[33:17];
assign chunk2  = in[50:34];
assign chunk3  = in[67:51];
assign chunk4  = in[84:68];
assign chunk5  = in[101:85];
assign chunk6  = in[118:102];
assign chunk7  = in[135:119];
assign chunk8  = in[152:136];
assign chunk9  = in[169:153];
assign chunk10 = in[186:170];
assign chunk11 = in[203:187];
assign chunk12 = in[220:204];
assign chunk13 = in[237:221];
assign chunk14 = in[254:238];

// Instantiate 15 population count circuits, one for each chunk
wire [4:0] count0, count1, count2, count3, count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14;
popcount17 u0 (.in(chunk0),  .out(count0));
popcount17 u1 (.in(chunk1),  .out(count1));
popcount17 u2 (.in(chunk2),  .out(count2));
popcount17 u3 (.in(chunk3),  .out(count3));
popcount17 u4 (.in(chunk4),  .out(count4));
popcount17 u5 (.in(chunk5),  .out(count5));
popcount17 u6 (.in(chunk6),  .out(count6));
popcount17 u7 (.in(chunk7),  .out(count7));
popcount17 u8 (.in(chunk8),  .out(count8));
popcount17 u9 (.in(chunk9),  .out(count9));
popcount17 u10(.in(chunk10), .out(count10));
popcount17 u11(.in(chunk11), .out(count11));
popcount17 u12(.in(chunk12), .out(count12));
popcount17 u13(.in(chunk13), .out(count13));
popcount17 u14(.in(chunk14), .out(count14));

// Sum up the counts from all chunks
reg [7:0] sum;
always @(count0, count1, count2, count3, count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14) begin
    sum = count0 + count1 + count2 + count3 + count4 + count5 + count6 + count7 + count8 + count9 + count10 + count11 + count12 + count13 + count14;
end
assign out = sum;

endmodule