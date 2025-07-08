module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Count '1's in each 8-bit segment (31 segments)
    wire [7:0] count [0:30];
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : COUNT_8BIT
            assign count[i] = 
                in[i*8 + 0] + in[i*8 + 1] + in[i*8 + 2] + in[i*8 + 3] +
                in[i*8 + 4] + in[i*8 + 5] + in[i*8 + 6] + in[i*8 + 7];
        end
    endgenerate

    // Count '1's in the remaining 7 bits
    wire [2:0] count_remaining;
    assign count_remaining = 
        in[248] + in[249] + in[250] + in[251] + 
        in[252] + in[253] + in[254];

    // Sum all partial counts
    wire [10:0] total; // Temporary sum (needs 11 bits for intermediate sums)
    assign total = 
        count[0] + count[1] + count[2] + count[3] + count[4] +
        count[5] + count[6] + count[7] + count[8] + count[9] +
        count[10] + count[11] + count[12] + count[13] + count[14] +
        count[15] + count[16] + count[17] + count[18] + count[19] +
        count[20] + count[21] + count[22] + count[23] + count[24] +
        count[25] + count[26] + count[27] + count[28] + count[29] +
        count[30] + count_remaining;

    assign out = total[7:0]; // Final 8-bit result

endmodule