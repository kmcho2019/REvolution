module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    wire [4:0] count0, count1, count2, count3, count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14, count15;
    wire [4:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8, sum9, sum10, sum11, sum12, sum13, sum14;
    wire [7:0] final_sum;

    // Population count for each 8-bit chunk
    PopulationCount8 in0 (.in(in[7:0]), .out(count0));
    PopulationCount8 in1 (.in(in[15:8]), .out(count1));
    PopulationCount8 in2 (.in(in[23:16]), .out(count2));
    PopulationCount8 in3 (.in(in[31:24]), .out(count3));
    PopulationCount8 in4 (.in(in[39:32]), .out(count4));
    PopulationCount8 in5 (.in(in[47:40]), .out(count5));
    PopulationCount8 in6 (.in(in[55:48]), .out(count6));
    PopulationCount8 in7 (.in(in[63:56]), .out(count7));
    PopulationCount8 in8 (.in(in[71:64]), .out(count8));
    PopulationCount8 in9 (.in(in[79:72]), .out(count9));
    PopulationCount8 in10 (.in(in[87:80]), .out(count10));
    PopulationCount8 in11 (.in(in[95:88]), .out(count11));
    PopulationCount8 in12 (.in(in[103:96]), .out(count12));
    PopulationCount8 in13 (.in(in[111:104]), .out(count13));
    PopulationCount8 in14 (.in(in[119:112]), .out(count14));
    PopulationCount8 in15 (.in(in[127:120]), .out(count15));

    // Sum the counts from all chunks in a tree-like structure
    Add5 sum0 (.a(count0), .b(count1), .out(sum0));
    Add5 sum1 (.a(count2), .b(count3), .out(sum1));
    Add5 sum2 (.a(count4), .b(count5), .out(sum2));
    Add5 sum3 (.a(count6), .b(count7), .out(sum3));
    Add5 sum4 (.a(count8), .b(count9), .out(sum4));
    Add5 sum5 (.a(count10), .b(count11), .out(sum5));
    Add5 sum6 (.a(count12), .b(count13), .out(sum6));
    Add5 sum7 (.a(count14), .b(count15), .out(sum7));

    Add5 sum8 (.a(sum0), .b(sum1), .out(sum8));
    Add5 sum9 (.a(sum2), .b(sum3), .out(sum9));
    Add5 sum10 (.a(sum4), .b(sum5), .out(sum10));
    Add5 sum11 (.a(sum6), .b(sum7), .out(sum11));

    Add5 sum12 (.a(sum8), .b(sum9), .out(sum12));
    Add5 sum13 (.a(sum10), .b(sum11), .out(sum13));

    Add5 sum14 (.a(sum12), .b(sum13), .out(sum14));

    // Count the last 7 bits separately
    PopulationCount7 in16 (.in(in[254:248]), .out(final_sum[4:0]));

    // Add the final sums together
    Add8 add (.a(final_sum), .b({3'b0, sum14}), .out(out));

endmodule

// Module to count the number of '1's in an 8-bit vector
module PopulationCount8(
    input [7:0] in,
    output [4:0] out
);

    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]} + {1'b0, in[3]} + {1'b0, in[4]} + {1'b0, in[5]} + {1'b0, in[6]} + {1'b0, in[7]};

endmodule

// Module to count the number of '1's in a 7-bit vector
module PopulationCount7(
    input [6:0] in,
    output [4:0] out
);

    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]} + {1'b0, in[3]} + {1'b0, in[4]} + {1'b0, in[5]} + {1'b0, in[6]};

endmodule

// Module to add two 5-bit numbers
module Add5(
    input [4:0] a,
    input [4:0] b,
    output [4:0] out
);

    assign out = a + b;

endmodule

// Module to add two 8-bit numbers
module Add8(
    input [7:0] a,
    input [7:0] b,
    output [7:0] out
);

    assign out = a + b;

endmodule