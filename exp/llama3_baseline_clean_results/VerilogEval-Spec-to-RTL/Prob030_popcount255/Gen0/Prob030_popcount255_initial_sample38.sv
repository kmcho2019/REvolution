module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    wire [7:0] count_0, count_1, count_2, count_3, count_4, count_5, count_6, count_7, count_8;
    wire [3:0] temp_count_0, temp_count_1, temp_count_2, temp_count_3, temp_count_4, temp_count_5, temp_count_6, temp_count_7, temp_count_8;

    // Count '1's in each 7-bit chunk and then sum them up for each 28-bit chunk
    bit_counter #(.WIDTH(7)) bc_0 (.in(in[6:0]), .out(temp_count_0));
    bit_counter #(.WIDTH(7)) bc_1 (.in(in[13:7]), .out(temp_count_1));
    bit_counter #(.WIDTH(7)) bc_2 (.in(in[20:14]), .out(temp_count_2));
    bit_counter #(.WIDTH(7)) bc_3 (.in(in[27:21]), .out(temp_count_3));
    bit_counter #(.WIDTH(7)) bc_4 (.in(in[34:28]), .out(temp_count_4));
    bit_counter #(.WIDTH(7)) bc_5 (.in(in[41:35]), .out(temp_count_5));
    bit_counter #(.WIDTH(7)) bc_6 (.in(in[48:42]), .out(temp_count_6));
    bit_counter #(.WIDTH(7)) bc_7 (.in(in[55:49]), .out(temp_count_7));
    bit_counter #(.WIDTH(7)) bc_8 (.in(in[62:56]), .out(temp_count_8));

    adder_4input #(.WIDTH(4)) add_0 (.in0(temp_count_0), .in1(temp_count_1), .in2(temp_count_2), .in3(temp_count_3), .out(count_0));
    adder_4input #(.WIDTH(4)) add_1 (.in0(temp_count_4), .in1(temp_count_5), .in2(temp_count_6), .in3(temp_count_7), .out(count_1));
    adder_4input #(.WIDTH(4)) add_2 (.in0(temp_count_8), .in1(4'b0), .in2(4'b0), .in3(4'b0), .out(count_2));

    bit_counter #(.WIDTH(7)) bc_9 (.in(in[69:63]), .out(temp_count_0));
    bit_counter #(.WIDTH(7)) bc_10 (.in(in[76:70]), .out(temp_count_1));
    bit_counter #(.WIDTH(7)) bc_11 (.in(in[83:77]), .out(temp_count_2));
    bit_counter #(.WIDTH(7)) bc_12 (.in(in[90:84]), .out(temp_count_3));
    bit_counter #(.WIDTH(7)) bc_13 (.in(in[97:91]), .out(temp_count_4));
    bit_counter #(.WIDTH(7)) bc_14 (.in(in[104:98]), .out(temp_count_5));
    bit_counter #(.WIDTH(7)) bc_15 (.in(in[111:105]), .out(temp_count_6));
    bit_counter #(.WIDTH(7)) bc_16 (.in(in[118:112]), .out(temp_count_7));
    bit_counter #(.WIDTH(7)) bc_17 (.in(in[125:119]), .out(temp_count_8));

    adder_4input #(.WIDTH(4)) add_3 (.in0(temp_count_0), .in1(temp_count_1), .in2(temp_count_2), .in3(temp_count_3), .out(count_3));
    adder_4input #(.WIDTH(4)) add_4 (.in0(temp_count_4), .in1(temp_count_5), .in2(temp_count_6), .in3(temp_count_7), .out(count_4));
    adder_4input #(.WIDTH(4)) add_5 (.in0(temp_count_8), .in1(4'b0), .in2(4'b0), .in3(4'b0), .out(count_5));

    bit_counter #(.WIDTH(7)) bc_18 (.in(in[132:126]), .out(temp_count_0));
    bit_counter #(.WIDTH(7)) bc_19 (.in(in[139:133]), .out(temp_count_1));
    bit_counter #(.WIDTH(7)) bc_20 (.in(in[146:140]), .out(temp_count_2));
    bit_counter #(.WIDTH(7)) bc_21 (.in(in[153:147]), .out(temp_count_3));
    bit_counter #(.WIDTH(7)) bc_22 (.in(in[160:154]), .out(temp_count_4));
    bit_counter #(.WIDTH(7)) bc_23 (.in(in[167:161]), .out(temp_count_5));
    bit_counter #(.WIDTH(7)) bc_24 (.in(in[174:168]), .out(temp_count_6));
    bit_counter #(.WIDTH(7)) bc_25 (.in(in[181:175]), .out(temp_count_7));
    bit_counter #(.WIDTH(7)) bc_26 (.in(in[188:182]), .out(temp_count_8));

    adder_4input #(.WIDTH(4)) add_6 (.in0(temp_count_0), .in1(temp_count_1), .in2(temp_count_2), .in3(temp_count_3), .out(count_6));
    adder_4input #(.WIDTH(4)) add_7 (.in0(temp_count_4), .in1(temp_count_5), .in2(temp_count_6), .in3(temp_count_7), .out(count_7));
    adder_4input #(.WIDTH(4)) add_8 (.in0(temp_count_8), .in1(4'b0), .in2(4'b0), .in3(4'b0), .out(count_8));

    // Now sum up all counts
    adder_4input #(.WIDTH(8)) add_final0 (.in0({4'b0, count_0}), .in1({4'b0, count_1}), .in2({4'b0, count_2}), .in3({4'b0, count_3}), .out(count_0));
    adder_4input #(.WIDTH(8)) add_final1 (.in0({4'b0, count_4}), .in1({4'b0, count_5}), .in2({4'b0, count_6}), .in3({4'b0, count_7}), .out(count_1));
    adder_4input #(.WIDTH(8)) add_final2 (.in0({4'b0, count_8}), .in1(8'b0), .in2(8'b0), .in3(8'b0), .out(count_2));

    adder_4input #(.WIDTH(8)) add_final3 (.in0(count_0), .in1(count_1), .in2(count_2), .in3(8'b0), .out(out));

endmodule

module bit_counter(
    input  [WIDTH-1:0] in,
    output [3:0] out
);
    parameter WIDTH = 7;
    reg [3:0] count;
    integer i;

    always @(*) begin
        count = 0;
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (in[i] == 1'b1) begin
                count = count + 1;
            end
        end
    end

    assign out = count;

endmodule

module adder_4input(
    input  [WIDTH-1:0] in0,
    input  [WIDTH-1:0] in1,
    input  [WIDTH-1:0] in2,
    input  [WIDTH-1:0] in3,
    output [WIDTH-1:0] out
);
    parameter WIDTH = 4;
    assign out = in0 + in1 + in2 + in3;

endmodule