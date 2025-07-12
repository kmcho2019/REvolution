module TopModule(
    input  [255:0] in,
    output [7:0] out
);

// Initialize the output
reg [7:0] out;

// Initialize wires to hold the counts
wire [7:0] count_0, count_1, count_2, count_3, count_4, count_5, count_6, count_7,
              count_8, count_9, count_10, count_11, count_12, count_13, count_14, count_15,
              count_16, count_17, count_18, count_19, count_20, count_21, count_22, count_23,
              count_24, count_25, count_26, count_27, count_28, count_29, count_30, count_31;

// Initialize wires to hold the sums
wire [8:0] sum_0, sum_1, sum_2, sum_3, sum_4, sum_5, sum_6, sum_7,
              sum_8, sum_9, sum_10, sum_11, sum_12, sum_13, sum_14, sum_15;

// Count the number of '1's in each group of 8 bits
population_count_8bit u_count_0 (.in(in[7:0]), .out(count_0));
population_count_8bit u_count_1 (.in(in[15:8]), .out(count_1));
population_count_8bit u_count_2 (.in(in[23:16]), .out(count_2));
population_count_8bit u_count_3 (.in(in[31:24]), .out(count_3));
population_count_8bit u_count_4 (.in(in[39:32]), .out(count_4));
population_count_8bit u_count_5 (.in(in[47:40]), .out(count_5));
population_count_8bit u_count_6 (.in(in[55:48]), .out(count_6));
population_count_8bit u_count_7 (.in(in[63:56]), .out(count_7));
population_count_8bit u_count_8 (.in(in[71:64]), .out(count_8));
population_count_8bit u_count_9 (.in(in[79:72]), .out(count_9));
population_count_8bit u_count_10 (.in(in[87:80]), .out(count_10));
population_count_8bit u_count_11 (.in(in[95:88]), .out(count_11));
population_count_8bit u_count_12 (.in(in[103:96]), .out(count_12));
population_count_8bit u_count_13 (.in(in[111:104]), .out(count_13));
population_count_8bit u_count_14 (.in(in[119:112]), .out(count_14));
population_count_8bit u_count_15 (.in(in[127:120]), .out(count_15));
population_count_8bit u_count_16 (.in(in[135:128]), .out(count_16));
population_count_8bit u_count_17 (.in(in[143:136]), .out(count_17));
population_count_8bit u_count_18 (.in(in[151:144]), .out(count_18));
population_count_8bit u_count_19 (.in(in[159:152]), .out(count_19));
population_count_8bit u_count_20 (.in(in[167:160]), .out(count_20));
population_count_8bit u_count_21 (.in(in[175:168]), .out(count_21));
population_count_8bit u_count_22 (.in(in[183:176]), .out(count_22));
population_count_8bit u_count_23 (.in(in[191:184]), .out(count_23));
population_count_8bit u_count_24 (.in(in[199:192]), .out(count_24));
population_count_8bit u_count_25 (.in(in[207:200]), .out(count_25));
population_count_8bit u_count_26 (.in(in[215:208]), .out(count_26));
population_count_8bit u_count_27 (.in(in[223:216]), .out(count_27));
population_count_8bit u_count_28 (.in(in[231:224]), .out(count_28));
population_count_8bit u_count_29 (.in(in[239:232]), .out(count_29));
population_count_8bit u_count_30 (.in(in[247:240]), .out(count_30));
population_count_8bit u_count_31 (.in(in[255:248]), .out(count_31));

// Sum up the counts
adder_8bit u_sum_0 (.in_a(count_0), .in_b(count_1), .out(sum_0));
adder_8bit u_sum_1 (.in_a(count_2), .in_b(count_3), .out(sum_1));
adder_8bit u_sum_2 (.in_a(count_4), .in_b(count_5), .out(sum_2));
adder_8bit u_sum_3 (.in_a(count_6), .in_b(count_7), .out(sum_3));
adder_8bit u_sum_4 (.in_a(count_8), .in_b(count_9), .out(sum_4));
adder_8bit u_sum_5 (.in_a(count_10), .in_b(count_11), .out(sum_5));
adder_8bit u_sum_6 (.in_a(count_12), .in_b(count_13), .out(sum_6));
adder_8bit u_sum_7 (.in_a(count_14), .in_b(count_15), .out(sum_7));
adder_8bit u_sum_8 (.in_a(count_16), .in_b(count_17), .out(sum_8));
adder_8bit u_sum_9 (.in_a(count_18), .in_b(count_19), .out(sum_9));
adder_8bit u_sum_10 (.in_a(count_20), .in_b(count_21), .out(sum_10));
adder_8bit u_sum_11 (.in_a(count_22), .in_b(count_23), .out(sum_11));
adder_8bit u_sum_12 (.in_a(count_24), .in_b(count_25), .out(sum_12));
adder_8bit u_sum_13 (.in_a(count_26), .in_b(count_27), .out(sum_13));
adder_8bit u_sum_14 (.in_a(count_28), .in_b(count_29), .out(sum_14));
adder_8bit u_sum_15 (.in_a(count_30), .in_b(count_31), .out(sum_15));

// Sum up the sums
adder_8bit u_sum_16 (.in_a(sum_0[7:0]), .in_b(sum_1[7:0]), .out(sum_8));
adder_8bit u_sum_17 (.in_a(sum_2[7:0]), .in_b(sum_3[7:0]), .out(sum_9));
adder_8bit u_sum_18 (.in_a(sum_4[7:0]), .in_b(sum_5[7:0]), .out(sum_10));
adder_8bit u_sum_19 (.in_a(sum_6[7:0]), .in_b(sum_7[7:0]), .out(sum_11));
adder_8bit u_sum_20 (.in_a(sum_8[7:0]), .in_b(sum_9[7:0]), .out(sum_12));
adder_8bit u_sum_21 (.in_a(sum_10[7:0]), .in_b(sum_11[7:0]), .out(sum_13));
adder_8bit u_sum_22 (.in_a(sum_12[7:0]), .in_b(sum_13[7:0]), .out(sum_14));
adder_8bit u_sum_23 (.in_a(sum_14[7:0]), .in_b(sum_15[7:0]), .out(out));

endmodule

module population_count_8bit(
    input [7:0] in,
    output [7:0] out
);

reg [7:0] out;

always @(*) begin
    out = 0;
    for (int i = 0; i < 8; i++) begin
        if (in[i] == 1'b1) begin
            out = out + 1;
        end
    end
end

endmodule

module adder_8bit(
    input [7:0] in_a,
    input [7:0] in_b,
    output [8:0] out
);

reg [8:0] out;

always @(*) begin
    out = in_a + in_b;
end

endmodule