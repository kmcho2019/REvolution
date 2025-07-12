module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Level 1: Count '1's in each 15-bit chunk
wire [3:0] count0, count1, count2, count3, count4, count5, count6, count7, 
         count8, count9, count10, count11, count12, count13, count14, count15, count16;

assign count0 = in[14:0] == 15'b111111111111111? 4'b1111 :
                in[14:0] == 15'b111111111111110? 4'b1110 :
                in[14:0] == 15'b111111111111101? 4'b1101 :
                //... (similarly for all possible 15-bit values)
                in[14:0] == 15'b000000000000001? 4'b0001 :
                in[14:0] == 15'b000000000000000? 4'b0000 :
                4'b0000;

//... (similarly for count1 to count16)

// Level 2: Sum counts from each chunk
wire [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;

assign sum0 = count0 + count1;
assign sum1 = count2 + count3;
assign sum2 = count4 + count5;
assign sum3 = count6 + count7;
assign sum4 = count8 + count9;
assign sum5 = count10 + count11;
assign sum6 = count12 + count13;
assign sum7 = count14 + count15;

// Level 3: Sum sums from each pair
wire [7:0] sum8, sum9, sum10, sum11;

assign sum8 = sum0 + sum1;
assign sum9 = sum2 + sum3;
assign sum10 = sum4 + sum5;
assign sum11 = sum6 + sum7;

// Level 4: Final sum
assign out = sum8 + sum9 + sum10 + sum11;

endmodule