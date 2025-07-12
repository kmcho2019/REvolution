module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Initialize count variables
    wire [4:0] count_0;
    wire [4:0] count_1;
    wire [4:0] count_2;
    wire [4:0] count_3;
    wire [4:0] count_4;
    wire [4:0] count_5;
    wire [4:0] count_6;
    wire [4:0] count_7;
    wire [4:0] count_8;

    // Count '1's in each group of 32 bits
    popcount_32 popcount_0 (.in(in[31:0]), .out(count_0));
    popcount_32 popcount_1 (.in(in[63:32]), .out(count_1));
    popcount_32 popcount_2 (.in(in[95:64]), .out(count_2));
    popcount_32 popcount_3 (.in(in[127:96]), .out(count_3));
    popcount_32 popcount_4 (.in(in[159:128]), .out(count_4));
    popcount_32 popcount_5 (.in(in[191:160]), .out(count_5));
    popcount_32 popcount_6 (.in(in[223:192]), .out(count_6));
    popcount_32 popcount_7 (.in(in[254:224]), .out(count_7));

    // Count '1's in the remaining 7 bits
    popcount_7 popcount_8 (.in({7'b0, in[6:0]}), .out(count_8));

    // Combine counts from each group
    wire [4:0] sum_0;
    wire [4:0] sum_1;
    wire [4:0] sum_2;
    wire [4:0] sum_3;

    assign sum_0 = count_0 + count_1;
    assign sum_1 = count_2 + count_3;
    assign sum_2 = count_4 + count_5;
    assign sum_3 = count_6 + count_7;

    wire [5:0] sum_4;
    wire [5:0] sum_5;

    assign sum_4 = sum_0 + sum_1;
    assign sum_5 = sum_2 + sum_3;

    wire [6:0] sum_6;

    assign sum_6 = sum_4 + sum_5;

    // Add count of remaining 7 bits
    assign out = sum_6[6:0] + count_8;

endmodule

// Module to count '1's in a 32-bit vector
module popcount_32(
    input  [31:0] in,
    output [4:0] out
);

    // Count '1's in each group of 4 bits
    wire [1:0] count_0;
    wire [1:0] count_1;
    wire [1:0] count_2;
    wire [1:0] count_3;
    wire [1:0] count_4;
    wire [1:0] count_5;
    wire [1:0] count_6;
    wire [1:0] count_7;

    popcount_4 popcount_0 (.in(in[3:0]), .out(count_0));
    popcount_4 popcount_1 (.in(in[7:4]), .out(count_1));
    popcount_4 popcount_2 (.in(in[11:8]), .out(count_2));
    popcount_4 popcount_3 (.in(in[15:12]), .out(count_3));
    popcount_4 popcount_4 (.in(in[19:16]), .out(count_4));
    popcount_4 popcount_5 (.in(in[23:20]), .out(count_5));
    popcount_4 popcount_6 (.in(in[27:24]), .out(count_6));
    popcount_4 popcount_7 (.in(in[31:28]), .out(count_7));

    // Combine counts from each group
    wire [2:0] sum_0;
    wire [2:0] sum_1;
    wire [2:0] sum_2;
    wire [2:0] sum_3;

    assign sum_0 = count_0 + count_1;
    assign sum_1 = count_2 + count_3;
    assign sum_2 = count_4 + count_5;
    assign sum_3 = count_6 + count_7;

    wire [3:0] sum_4;
    wire [3:0] sum_5;

    assign sum_4 = sum_0 + sum_1;
    assign sum_5 = sum_2 + sum_3;

    assign out = sum_4 + sum_5;

endmodule

// Module to count '1's in a 4-bit vector
module popcount_4(
    input  [3:0] in,
    output [1:0] out
);

    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]} + {1'b0, in[3]};

endmodule

// Module to count '1's in a 7-bit vector (for the remaining bits)
module popcount_7(
    input  [6:0] in,
    output [4:0] out
);

    assign out = {2'b0, in[0]} + {2'b0, in[1]} + {2'b0, in[2]} + {2'b0, in[3]} +
                 {2'b0, in[4]} + {2'b0, in[5]} + {2'b0, in[6]};

endmodule