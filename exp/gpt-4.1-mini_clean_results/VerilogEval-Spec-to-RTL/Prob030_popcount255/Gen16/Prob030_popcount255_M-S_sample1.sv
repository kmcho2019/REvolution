module popcount8 (
    input  [7:0] in,
    output [3:0] out // max 8 ones fits in 4 bits
);
    // Sum lower 4 bits
    wire [2:0] sum_lo;
    assign sum_lo = in[0] + in[1] + in[2] + in[3]; // max 4, needs 3 bits

    // Sum upper 4 bits
    wire [2:0] sum_hi;
    assign sum_hi = in[4] + in[5] + in[6] + in[7]; // max 4, needs 3 bits

    assign out = sum_lo + sum_hi; // 3-bit + 3-bit = 4-bit sum
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Split input into 32 chunks of 8 bits (last chunk padded with zeros)
    wire [3:0] pc8 [31:0]; // popcount8 outputs

    // Chunk 0 to 30: full 8 bits from input
    popcount8 pc0 (.in(in[7:0]),       .out(pc8[0]));
    popcount8 pc1 (.in(in[15:8]),      .out(pc8[1]));
    popcount8 pc2 (.in(in[23:16]),     .out(pc8[2]));
    popcount8 pc3 (.in(in[31:24]),     .out(pc8[3]));
    popcount8 pc4 (.in(in[39:32]),     .out(pc8[4]));
    popcount8 pc5 (.in(in[47:40]),     .out(pc8[5]));
    popcount8 pc6 (.in(in[55:48]),     .out(pc8[6]));
    popcount8 pc7 (.in(in[63:56]),     .out(pc8[7]));
    popcount8 pc8_ (.in(in[71:64]),    .out(pc8[8]));
    popcount8 pc9 (.in(in[79:72]),     .out(pc8[9]));
    popcount8 pc10(.in(in[87:80]),     .out(pc8[10]));
    popcount8 pc11(.in(in[95:88]),     .out(pc8[11]));
    popcount8 pc12(.in(in[103:96]),    .out(pc8[12]));
    popcount8 pc13(.in(in[111:104]),   .out(pc8[13]));
    popcount8 pc14(.in(in[119:112]),   .out(pc8[14]));
    popcount8 pc15(.in(in[127:120]),   .out(pc8[15]));
    popcount8 pc16(.in(in[135:128]),   .out(pc8[16]));
    popcount8 pc17(.in(in[143:136]),   .out(pc8[17]));
    popcount8 pc18(.in(in[151:144]),   .out(pc8[18]));
    popcount8 pc19(.in(in[159:152]),   .out(pc8[19]));
    popcount8 pc20(.in(in[167:160]),   .out(pc8[20]));
    popcount8 pc21(.in(in[175:168]),   .out(pc8[21]));
    popcount8 pc22(.in(in[183:176]),   .out(pc8[22]));
    popcount8 pc23(.in(in[191:184]),   .out(pc8[23]));
    popcount8 pc24(.in(in[199:192]),   .out(pc8[24]));
    popcount8 pc25(.in(in[207:200]),   .out(pc8[25]));
    popcount8 pc26(.in(in[215:208]),   .out(pc8[26]));
    popcount8 pc27(.in(in[223:216]),   .out(pc8[27]));
    popcount8 pc28(.in(in[231:224]),   .out(pc8[28]));
    popcount8 pc29(.in(in[239:232]),   .out(pc8[29]));
    popcount8 pc30(.in(in[247:240]),   .out(pc8[30]));

    // Chunk 31: last 7 bits + 1 zero padding bit
    wire [7:0] last_chunk;
    assign last_chunk = {1'b0, in[254:248]}; // MSB padded zero to make 8 bits
    popcount8 pc31(.in(last_chunk), .out(pc8[31]));

    // Sum all 32 pc8 outputs (4-bit each) in balanced binary tree

    // Level 1: 16 sums 5-bit (4+4 bits + 1 bit possible carry)
    wire [4:0] sum_l1 [15:0];
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : level1
            assign sum_l1[i] = pc8[2*i] + pc8[2*i+1];
        end
    endgenerate

    // Level 2: 8 sums 6-bit
    wire [5:0] sum_l2 [7:0];
    generate
        for (i=0; i<8; i=i+1) begin : level2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    // Level 3: 4 sums 7-bit
    wire [6:0] sum_l3 [3:0];
    generate
        for (i=0; i<4; i=i+1) begin : level3
            assign sum_l3[i] = sum_l2[2*i] + sum_l2[2*i+1];
        end
    endgenerate

    // Level 4: 2 sums 8-bit
    wire [7:0] sum_l4 [1:0];
    assign sum_l4[0] = sum_l3[0] + sum_l3[1];
    assign sum_l4[1] = sum_l3[2] + sum_l3[3];

    // Level 5: final sum 8-bit output
    assign out = sum_l4[0] + sum_l4[1];

endmodule