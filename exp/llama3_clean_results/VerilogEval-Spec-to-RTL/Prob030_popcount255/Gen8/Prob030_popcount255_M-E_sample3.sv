module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input vector into 15 chunks of 17 bits each
wire [16:0] chunk0 = in[16:0];
wire [16:0] chunk1 = in[33:17];
wire [16:0] chunk2 = in[50:34];
wire [16:0] chunk3 = in[67:51];
wire [16:0] chunk4 = in[84:68];
wire [16:0] chunk5 = in[101:85];
wire [16:0] chunk6 = in[118:102];
wire [16:0] chunk7 = in[135:119];
wire [16:0] chunk8 = in[152:136];
wire [16:0] chunk9 = in[169:153];
wire [16:0] chunk10 = in[186:170];
wire [16:0] chunk11 = in[203:187];
wire [16:0] chunk12 = in[220:204];
wire [16:0] chunk13 = in[237:221];
wire [16:0] chunk14 = in[254:238];

// Count the number of '1's in each chunk using a 4-bit counter
wire [3:0] count0 = count_ones(chunk0);
wire [3:0] count1 = count_ones(chunk1);
wire [3:0] count2 = count_ones(chunk2);
wire [3:0] count3 = count_ones(chunk3);
wire [3:0] count4 = count_ones(chunk4);
wire [3:0] count5 = count_ones(chunk5);
wire [3:0] count6 = count_ones(chunk6);
wire [3:0] count7 = count_ones(chunk7);
wire [3:0] count8 = count_ones(chunk8);
wire [3:0] count9 = count_ones(chunk9);
wire [3:0] count10 = count_ones(chunk10);
wire [3:0] count11 = count_ones(chunk11);
wire [3:0] count12 = count_ones(chunk12);
wire [3:0] count13 = count_ones(chunk13);
wire [3:0] count14 = count_ones(chunk14);

// Combine the counts using a tree of adders
wire [7:0] sum0 = count0 + count1;
wire [7:0] sum1 = count2 + count3;
wire [7:0] sum2 = count4 + count5;
wire [7:0] sum3 = count6 + count7;
wire [7:0] sum4 = count8 + count9;
wire [7:0] sum5 = count10 + count11;
wire [7:0] sum6 = count12 + count13;
wire [7:0] sum7 = count14;

wire [7:0] sum8 = sum0 + sum1;
wire [7:0] sum9 = sum2 + sum3;
wire [7:0] sum10 = sum4 + sum5;
wire [7:0] sum11 = sum6 + sum7;

wire [7:0] sum12 = sum8 + sum9;
wire [7:0] sum13 = sum10 + sum11;

wire [7:0] final_sum = sum12 + sum13;

assign out = final_sum;

// Function to count the number of '1's in a 17-bit vector
function [3:0] count_ones;
    input [16:0] in;
    reg [3:0] count;
    integer i;
    begin
        count = 0;
        for (i = 0; i < 17; i = i + 1) begin
            if (in[i] == 1'b1) begin
                count = count + 1;
            end
        end
        count_ones = count;
    end
endfunction

endmodule