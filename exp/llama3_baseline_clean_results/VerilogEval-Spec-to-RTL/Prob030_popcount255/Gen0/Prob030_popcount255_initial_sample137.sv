module TopModule(
    input [255:0] in,
    output [7:0] out
);

    wire [7:0] count_1, count_2, count_3, count_4, count_5, count_6, count_7, count_8;
    wire [7:0] sum_1, sum_2, sum_3, sum_4, sum_5, sum_6, sum_7;

    // Counting '1's in each byte
    PopCount8 pop_count_1(.in(in[7:0]), .out(count_1));
    PopCount8 pop_count_2(.in(in[15:8]), .out(count_2));
    PopCount8 pop_count_3(.in(in[23:16]), .out(count_3));
    PopCount8 pop_count_4(.in(in[31:24]), .out(count_4));
    PopCount8 pop_count_5(.in(in[39:32]), .out(count_5));
    PopCount8 pop_count_6(.in(in[47:40]), .out(count_6));
    PopCount8 pop_count_7(.in(in[55:48]), .out(count_7));
    PopCount8 pop_count_8(.in(in[63:56]), .out(count_8));
    PopCount8 pop_count_9(.in(in[71:64]), .out(sum_1));
    PopCount8 pop_count_10(.in(in[79:72]), .out(sum_2));
    PopCount8 pop_count_11(.in(in[87:80]), .out(sum_3));
    PopCount8 pop_count_12(.in(in[95:88]), .out(sum_4));
    PopCount8 pop_count_13(.in(in[103:96]), .out(sum_5));
    PopCount8 pop_count_14(.in(in[111:104]), .out(sum_6));
    PopCount8 pop_count_15(.in(in[119:112]), .out(sum_7));
    PopCount8 pop_count_16(.in(in[127:120]), .out(count_1));
    PopCount8 pop_count_17(.in(in[135:128]), .out(count_2));
    PopCount8 pop_count_18(.in(in[143:136]), .out(count_3));
    PopCount8 pop_count_19(.in(in[151:144]), .out(count_4));
    PopCount8 pop_count_20(.in(in[159:152]), .out(count_5));
    PopCount8 pop_count_21(.in(in[167:160]), .out(count_6));
    PopCount8 pop_count_22(.in(in[175:168]), .out(count_7));
    PopCount8 pop_count_23(.in(in[183:176]), .out(count_8));
    PopCount8 pop_count_24(.in(in[191:184]), .out(sum_1));
    PopCount8 pop_count_25(.in(in[199:192]), .out(sum_2));
    PopCount8 pop_count_26(.in(in[207:200]), .out(sum_3));
    PopCount8 pop_count_27(.in(in[215:208]), .out(sum_4));
    PopCount8 pop_count_28(.in(in[223:216]), .out(sum_5));
    PopCount8 pop_count_29(.in(in[231:224]), .out(sum_6));
    PopCount8 pop_count_30(.in(in[239:232]), .out(sum_7));
    PopCount8 pop_count_31(.in(in[247:240]), .out(count_1));
    PopCount8 pop_count_32(.in(in[255:248]), .out(count_2));

    // Summing up counts from each byte
    Add8 add_1(.in1(count_1), .in2(count_2), .out(sum_1));
    Add8 add_2(.in1(count_3), .in2(count_4), .out(sum_2));
    Add8 add_3(.in1(count_5), .in2(count_6), .out(sum_3));
    Add8 add_4(.in1(count_7), .in2(count_8), .out(sum_4));
    Add8 add_5(.in1(sum_1), .in2(sum_2), .out(sum_5));
    Add8 add_6(.in1(sum_3), .in2(sum_4), .out(sum_6));
    Add8 add_7(.in1(sum_5), .in2(sum_6), .out(sum_7));

    // Final sum
    Add8 add_8(.in1(sum_7), .in2(sum_7), .out(out));

endmodule

module PopCount8(
    input [7:0] in,
    output [7:0] out
);
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]} + {1'b0, in[3]} +
                 {1'b0, in[4]} + {1'b0, in[5]} + {1'b0, in[6]} + {1'b0, in[7]};
endmodule

module Add8(
    input [7:0] in1,
    input [7:0] in2,
    output [7:0] out
);
    assign out = in1 + in2;
endmodule