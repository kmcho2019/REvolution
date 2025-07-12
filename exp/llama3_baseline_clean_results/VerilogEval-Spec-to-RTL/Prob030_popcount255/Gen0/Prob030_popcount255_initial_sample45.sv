module TopModule (
    input  [254:0] in,  // 255-bit input vector
    output [7:0]   out  // 8-bit output for population count
);

    // Initialize the count
    wire [7:0] count_byte0;
    wire [7:0] count_byte1;
    wire [7:0] count_byte2;
    wire [7:0] count_byte3;
    wire [7:0] count_byte4;
    wire [7:0] count_byte5;
    wire [7:0] count_byte6;
    wire [7:0] count_byte7;
    wire [7:0] count_byte8;
    wire [7:0] count_byte9;
    wire [7:0] count_byte10;
    wire [7:0] count_byte11;
    wire [7:0] count_byte12;
    wire [7:0] count_byte13;
    wire [7:0] count_byte14;
    wire [7:0] count_byte15;
    wire [7:0] count_byte16;
    wire [7:0] count_byte17;
    wire [7:0] count_byte18;
    wire [7:0] count_byte19;
    wire [7:0] count_byte20;
    wire [7:0] count_byte21;
    wire [7:0] count_byte22;
    wire [7:0] count_byte23;
    wire [7:0] count_byte24;
    wire [7:0] count_byte25;
    wire [7:0] count_byte26;
    wire [7:0] count_byte27;
    wire [7:0] count_byte28;
    wire [7:0] count_byte29;
    wire [7:0] count_byte30;
    wire [7:0] count_byte31;

    // Count the number of '1's in each byte
    popcount_byte popcount_byte0 (.in(in[7:0]), .count(count_byte0));
    popcount_byte popcount_byte1 (.in(in[15:8]), .count(count_byte1));
    popcount_byte popcount_byte2 (.in(in[23:16]), .count(count_byte2));
    popcount_byte popcount_byte3 (.in(in[31:24]), .count(count_byte3));
    popcount_byte popcount_byte4 (.in(in[39:32]), .count(count_byte4));
    popcount_byte popcount_byte5 (.in(in[47:40]), .count(count_byte5));
    popcount_byte popcount_byte6 (.in(in[55:48]), .count(count_byte6));
    popcount_byte popcount_byte7 (.in(in[63:56]), .count(count_byte7));
    popcount_byte popcount_byte8 (.in(in[71:64]), .count(count_byte8));
    popcount_byte popcount_byte9 (.in(in[79:72]), .count(count_byte9));
    popcount_byte popcount_byte10 (.in(in[87:80]), .count(count_byte10));
    popcount_byte popcount_byte11 (.in(in[95:88]), .count(count_byte11));
    popcount_byte popcount_byte12 (.in(in[103:96]), .count(count_byte12));
    popcount_byte popcount_byte13 (.in(in[111:104]), .count(count_byte13));
    popcount_byte popcount_byte14 (.in(in[119:112]), .count(count_byte14));
    popcount_byte popcount_byte15 (.in(in[127:120]), .count(count_byte15));
    popcount_byte popcount_byte16 (.in(in[135:128]), .count(count_byte16));
    popcount_byte popcount_byte17 (.in(in[143:136]), .count(count_byte17));
    popcount_byte popcount_byte18 (.in(in[151:144]), .count(count_byte18));
    popcount_byte popcount_byte19 (.in(in[159:152]), .count(count_byte19));
    popcount_byte popcount_byte20 (.in(in[167:160]), .count(count_byte20));
    popcount_byte popcount_byte21 (.in(in[175:168]), .count(count_byte21));
    popcount_byte popcount_byte22 (.in(in[183:176]), .count(count_byte22));
    popcount_byte popcount_byte23 (.in(in[191:184]), .count(count_byte23));
    popcount_byte popcount_byte24 (.in(in[199:192]), .count(count_byte24));
    popcount_byte popcount_byte25 (.in(in[207:200]), .count(count_byte25));
    popcount_byte popcount_byte26 (.in(in[215:208]), .count(count_byte26));
    popcount_byte popcount_byte27 (.in(in[223:216]), .count(count_byte27));
    popcount_byte popcount_byte28 (.in(in[231:224]), .count(count_byte28));
    popcount_byte popcount_byte29 (.in(in[239:232]), .count(count_byte29));
    popcount_byte popcount_byte30 (.in(in[247:240]), .count(count_byte30));
    popcount_byte popcount_byte31 (.in(in[254:247]), .count(count_byte31));

    // Add up the counts from each byte using a series of adders
    wire [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8, sum9, sum10, sum11, sum12, sum13, sum14, sum15;
    assign sum0 = count_byte0 + count_byte1;
    assign sum1 = count_byte2 + count_byte3;
    assign sum2 = count_byte4 + count_byte5;
    assign sum3 = count_byte6 + count_byte7;
    assign sum4 = count_byte8 + count_byte9;
    assign sum5 = count_byte10 + count_byte11;
    assign sum6 = count_byte12 + count_byte13;
    assign sum7 = count_byte14 + count_byte15;
    assign sum8 = count_byte16 + count_byte17;
    assign sum9 = count_byte18 + count_byte19;
    assign sum10 = count_byte20 + count_byte21;
    assign sum11 = count_byte22 + count_byte23;
    assign sum12 = count_byte24 + count_byte25;
    assign sum13 = count_byte26 + count_byte27;
    assign sum14 = count_byte28 + count_byte29;
    assign sum15 = count_byte30 + count_byte31;

    wire [7:0] sum16, sum17, sum18, sum19, sum20, sum21, sum22, sum23;
    assign sum16 = sum0 + sum1;
    assign sum17 = sum2 + sum3;
    assign sum18 = sum4 + sum5;
    assign sum19 = sum6 + sum7;
    assign sum20 = sum8 + sum9;
    assign sum21 = sum10 + sum11;
    assign sum22 = sum12 + sum13;
    assign sum23 = sum14 + sum15;

    wire [7:0] sum24, sum25, sum26, sum27;
    assign sum24 = sum16 + sum17;
    assign sum25 = sum18 + sum19;
    assign sum26 = sum20 + sum21;
    assign sum27 = sum22 + sum23;

    wire [7:0] sum28, sum29;
    assign sum28 = sum24 + sum25;
    assign sum29 = sum26 + sum27;

    wire [7:0] sum30;
    assign sum30 = sum28 + sum29;

    assign out = sum30;

endmodule

module popcount_byte (
    input  [7:0] in,  // 8-bit input
    output [7:0] count  // count of '1's in the input
);

    assign count = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7];

endmodule