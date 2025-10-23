module TopModule(in, out);
    input [255:0] in;
    output [7:0] out;

    wire [7:0] count0, count1, count2, count3, count4, count5, count6, count7;
    wire [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6;

    // Count 1's in each byte
    for (genvar i = 0; i < 32; i = i + 1) begin: count_bytes
        assign count0[i] = in[i*8 +: 8][0] + in[i*8 +: 8][1] + in[i*8 +: 8][2] + in[i*8 +: 8][3] + 
                          in[i*8 +: 8][4] + in[i*8 +: 8][5] + in[i*8 +: 8][6] + in[i*8 +: 8][7];
    end

    // Sum counts from each byte
    for (genvar i = 0; i < 16; i = i + 1) begin: sum_bytes
        assign sum0[i] = count0[i*2] + count0[i*2 + 1];
    end

    // Sum counts from each group of 2 bytes
    for (genvar i = 0; i < 8; i = i + 1) begin: sum_2bytes
        assign sum1[i] = sum0[i*2] + sum0[i*2 + 1];
    end

    // Sum counts from each group of 4 bytes
    for (genvar i = 0; i < 4; i = i + 1) begin: sum_4bytes
        assign sum2[i] = sum1[i*2] + sum1[i*2 + 1];
    end

    // Sum counts from each group of 8 bytes
    for (genvar i = 0; i < 2; i = i + 1) begin: sum_8bytes
        assign sum3[i] = sum2[i*2] + sum2[i*2 + 1];
    end

    // Sum counts from each group of 16 bytes
    assign sum4[0] = sum3[0] + sum3[1];

    // Output the final count
    assign out = sum4[0];
endmodule