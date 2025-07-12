module popcount8 (
    input  [7:0] in,
    output [3:0] out // max 8 ones fits in 4 bits
);
    // Explicit popcount by summing bits, no loops or functions
    wire [3:0] sum0, sum1;

    // Sum lower 4 bits
    wire [2:0] sum_lo;
    assign sum_lo = in[0] + in[1] + in[2] + in[3]; // max 4, needs 3 bits

    // Sum upper 4 bits
    wire [2:0] sum_hi;
    assign sum_hi = in[4] + in[5] + in[6] + in[7]; // max 4, needs 3 bits

    // sum_lo and sum_hi are 3-bit each (max 4), sum can be max 8 -> 4 bits needed
    assign out = sum_lo + sum_hi; // 3-bit + 3-bit = 4-bit sum
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Input is 255 bits; split into 32 groups of 8 bits (last group zero padded for 7 bits)
    // 255 bits / 8 = 31 full groups + 1 partial group (7 bits)
    wire [3:0] pc8 [31:0]; // popcount8 outputs 4-bit sums

    // Assign all full 8-bit groups
    assign pc8[0]  = popcount8_fn(in[7:0]);
    assign pc8[1]  = popcount8_fn(in[15:8]);
    assign pc8[2]  = popcount8_fn(in[23:16]);
    assign pc8[3]  = popcount8_fn(in[31:24]);
    assign pc8[4]  = popcount8_fn(in[39:32]);
    assign pc8[5]  = popcount8_fn(in[47:40]);
    assign pc8[6]  = popcount8_fn(in[55:48]);
    assign pc8[7]  = popcount8_fn(in[63:56]);
    assign pc8[8]  = popcount8_fn(in[71:64]);
    assign pc8[9]  = popcount8_fn(in[79:72]);
    assign pc8[10] = popcount8_fn(in[87:80]);
    assign pc8[11] = popcount8_fn(in[95:88]);
    assign pc8[12] = popcount8_fn(in[103:96]);
    assign pc8[13] = popcount8_fn(in[111:104]);
    assign pc8[14] = popcount8_fn(in[119:112]);
    assign pc8[15] = popcount8_fn(in[127:120]);
    assign pc8[16] = popcount8_fn(in[135:128]);
    assign pc8[17] = popcount8_fn(in[143:136]);
    assign pc8[18] = popcount8_fn(in[151:144]);
    assign pc8[19] = popcount8_fn(in[159:152]);
    assign pc8[20] = popcount8_fn(in[167:160]);
    assign pc8[21] = popcount8_fn(in[175:168]);
    assign pc8[22] = popcount8_fn(in[183:176]);
    assign pc8[23] = popcount8_fn(in[191:184]);
    assign pc8[24] = popcount8_fn(in[199:192]);
    assign pc8[25] = popcount8_fn(in[207:200]);
    assign pc8[26] = popcount8_fn(in[215:208]);
    assign pc8[27] = popcount8_fn(in[223:216]);
    assign pc8[28] = popcount8_fn(in[231:224]);
    assign pc8[29] = popcount8_fn(in[239:232]);
    assign pc8[30] = popcount8_fn(in[247:240]);

    // For last partial 7 bits, pad MSB with zero
    wire [7:0] last_chunk;
    assign last_chunk = {1'b0, in[254:248]}; // 7 bits + 1 zero MSB
    assign pc8[31] = popcount8_fn(last_chunk);

    // Now sum 32 partial 4-bit counts in a balanced tree of adders
    // Level 1: 16 sums of 4-bit + 4-bit -> 5-bit sums
    wire [4:0] sum_l1 [15:0];
    assign sum_l1[0]  = pc8[0]  + pc8[1];
    assign sum_l1[1]  = pc8[2]  + pc8[3];
    assign sum_l1[2]  = pc8[4]  + pc8[5];
    assign sum_l1[3]  = pc8[6]  + pc8[7];
    assign sum_l1[4]  = pc8[8]  + pc8[9];
    assign sum_l1[5]  = pc8[10] + pc8[11];
    assign sum_l1[6]  = pc8[12] + pc8[13];
    assign sum_l1[7]  = pc8[14] + pc8[15];
    assign sum_l1[8]  = pc8[16] + pc8[17];
    assign sum_l1[9]  = pc8[18] + pc8[19];
    assign sum_l1[10] = pc8[20] + pc8[21];
    assign sum_l1[11] = pc8[22] + pc8[23];
    assign sum_l1[12] = pc8[24] + pc8[25];
    assign sum_l1[13] = pc8[26] + pc8[27];
    assign sum_l1[14] = pc8[28] + pc8[29];
    assign sum_l1[15] = pc8[30] + pc8[31];

    // Level 2: 8 sums of 5-bit + 5-bit -> 6-bit sums
    wire [5:0] sum_l2 [7:0];
    assign sum_l2[0] = sum_l1[0] + sum_l1[1];
    assign sum_l2[1] = sum_l1[2] + sum_l1[3];
    assign sum_l2[2] = sum_l1[4] + sum_l1[5];
    assign sum_l2[3] = sum_l1[6] + sum_l1[7];
    assign sum_l2[4] = sum_l1[8] + sum_l1[9];
    assign sum_l2[5] = sum_l1[10] + sum_l1[11];
    assign sum_l2[6] = sum_l1[12] + sum_l1[13];
    assign sum_l2[7] = sum_l1[14] + sum_l1[15];

    // Level 3: 4 sums of 6-bit + 6-bit -> 7-bit sums
    wire [6:0] sum_l3 [3:0];
    assign sum_l3[0] = sum_l2[0] + sum_l2[1];
    assign sum_l3[1] = sum_l2[2] + sum_l2[3];
    assign sum_l3[2] = sum_l2[4] + sum_l2[5];
    assign sum_l3[3] = sum_l2[6] + sum_l2[7];

    // Level 4: 2 sums of 7-bit + 7-bit -> 8-bit sums
    wire [7:0] sum_l4 [1:0];
    assign sum_l4[0] = sum_l3[0] + sum_l3[1];
    assign sum_l4[1] = sum_l3[2] + sum_l3[3];

    // Level 5: final sum of two 8-bit sums -> max 8 bits needed (max count is 255, fits in 8 bits)
    assign out = sum_l4[0] + sum_l4[1];

    // Function to instantiate popcount8 module behaviorally inline (avoid always/generate)
    function [3:0] popcount8_fn;
        input [7:0] bits;
        integer i;
        begin
            popcount8_fn = 0;
            for(i=0; i<8; i=i+1)
                popcount8_fn = popcount8_fn + bits[i];
        end
    endfunction
endmodule