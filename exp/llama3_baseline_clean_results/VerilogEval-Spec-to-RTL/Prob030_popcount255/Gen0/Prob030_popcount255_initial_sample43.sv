module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Count the number of '1's in each 8-bit group
    wire [7:0] count_8bit [31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i++) begin
            popcount_8bit u_popcount_8bit(
                .in(in[8*i + 7 : 8*i]),
                .out(count_8bit[i])
            );
        end
    endgenerate

    // Count the number of '1's in the last 7-bit group
    wire [6:0] count_7bit;
    popcount_7bit u_popcount_7bit(
        .in(in[254:248]),
        .out(count_7bit)
    );

    // Add the counts from each group
    wire [8:0] sum_count;
    assign sum_count = count_8bit[0] + count_8bit[1] + count_8bit[2] + count_8bit[3] +
                       count_8bit[4] + count_8bit[5] + count_8bit[6] + count_8bit[7] +
                       count_8bit[8] + count_8bit[9] + count_8bit[10] + count_8bit[11] +
                       count_8bit[12] + count_8bit[13] + count_8bit[14] + count_8bit[15] +
                       count_8bit[16] + count_8bit[17] + count_8bit[18] + count_8bit[19] +
                       count_8bit[20] + count_8bit[21] + count_8bit[22] + count_8bit[23] +
                       count_8bit[24] + count_8bit[25] + count_8bit[26] + count_8bit[27] +
                       count_8bit[28] + count_8bit[29] + count_8bit[30] + count_8bit[31] +
                       {1'b0, count_7bit};

    // Output the result
    assign out = sum_count[8:1];

endmodule

// Population count module for 8-bit input
module popcount_8bit(
    input [7:0] in,
    output [3:0] out
);
    assign out = {1'b0, in[7]} + {1'b0, in[6]} + {1'b0, in[5]} + {1'b0, in[4]} +
                 {1'b0, in[3]} + {1'b0, in[2]} + {1'b0, in[1]} + {1'b0, in[0]};
endmodule

// Population count module for 7-bit input
module popcount_7bit(
    input [6:0] in,
    output [2:0] out
);
    assign out = {1'b0, in[6]} + {1'b0, in[5]} + {1'b0, in[4]} +
                 {1'b0, in[3]} + {1'b0, in[2]} + {1'b0, in[1]} + {1'b0, in[0]};
endmodule