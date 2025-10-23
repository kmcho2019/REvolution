module TopModule(
    input [254:0] in,
    output [7:0] out
);

    wire [7:0] count_8bit [31:0];
    wire [6:0] count_7bit;

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin
            pop_count_8bit u_pop_count_8bit(
                .in(in[8*i+7:8*i]),
                .out(count_8bit[i])
            );
        end
    endgenerate

    pop_count_7bit u_pop_count_7bit(
        .in(in[248:255-7]),
        .out(count_7bit)
    );

    wire [7:0] count_sum_16;
    adder_8bit u_adder_8bit_0(
        .a(count_8bit[0]),
        .b(count_8bit[1]),
        .out(count_sum_16)
    );

    wire [7:0] count_sum_32;
    adder_8bit_tree u_adder_8bit_tree(
        .in(count_8bit[2:31]),
        .out(count_sum_32)
    );

    adder_9bit u_adder_9bit_0(
        .a(count_sum_16),
        .b(count_sum_32),
        .out(out[7:0])
    );

    // population count for 8-bit vector
    module pop_count_8bit(
        input [7:0] in,
        output [7:0] out
    );
        assign out = {8{1'b0}} +
                     (in[0] ? 8'b1 : 8'b0) +
                     (in[1] ? 8'b1 : 8'b0) +
                     (in[2] ? 8'b1 : 8'b0) +
                     (in[3] ? 8'b1 : 8'b0) +
                     (in[4] ? 8'b1 : 8'b0) +
                     (in[5] ? 8'b1 : 8'b0) +
                     (in[6] ? 8'b1 : 8'b0) +
                     (in[7] ? 8'b1 : 8'b0);
    endmodule

    // population count for 7-bit vector
    module pop_count_7bit(
        input [6:0] in,
        output [6:0] out
    );
        assign out = {7{1'b0}} +
                     (in[0] ? 7'b1 : 7'b0) +
                     (in[1] ? 7'b1 : 7'b0) +
                     (in[2] ? 7'b1 : 7'b0) +
                     (in[3] ? 7'b1 : 7'b0) +
                     (in[4] ? 7'b1 : 7'b0) +
                     (in[5] ? 7'b1 : 7'b0) +
                     (in[6] ? 7'b1 : 7'b0);
    endmodule

    // adder for 8-bit numbers
    module adder_8bit(
        input [7:0] a,
        input [7:0] b,
        output [7:0] out
    );
        assign out = a + b;
    endmodule

    // adder for 9-bit numbers
    module adder_9bit(
        input [7:0] a,
        input [7:0] b,
        output [7:0] out
    );
        assign out = (a + b)[7:0];
    endmodule

    // adder tree for 8-bit numbers
    module adder_8bit_tree(
        input [7:0] in [31:2],
        output [7:0] out
    );
        wire [7:0] sum_8bit [15:0];
        genvar j;
        generate
            for (j = 0; j < 15; j = j + 1) begin
                if (j < 15) begin
                    adder_8bit u_adder_8bit(
                        .a(in[j*2]),
                        .b(in[j*2+1]),
                        .out(sum_8bit[j])
                    );
                end else begin
                    assign sum_8bit[j] = in[j*2];
                end
            end
        endgenerate

        adder_8bit_tree_4 u_adder_8bit_tree_4(
            .in(sum_8bit[0:3]),
            .out(sum_8bit[15])
        );

        adder_8bit_tree_4 u_adder_8bit_tree_4_1(
            .in(sum_8bit[4:7]),
            .out(sum_8bit[14])
        );

        adder_8bit_tree_4 u_adder_8bit_tree_4_2(
            .in(sum_8bit[8:11]),
            .out(sum_8bit[13])
        );

        adder_8bit_tree_4 u_adder_8bit_tree_4_3(
            .in(sum_8bit[12:15]),
            .out(out)
        );
    endmodule

    // adder tree for 4 8-bit numbers
    module adder_8bit_tree_4(
        input [7:0] in [3:0],
        output [7:0] out
    );
        wire [7:0] sum_8bit_1;
        wire [7:0] sum_8bit_2;
        adder_8bit u_adder_8bit_1(
            .a(in[0]),
            .b(in[1]),
            .out(sum_8bit_1)
        );
        adder_8bit u_adder_8bit_2(
            .a(in[2]),
            .b(in[3]),
            .out(sum_8bit_2)
        );
        adder_8bit u_adder_8bit_3(
            .a(sum_8bit_1),
            .b(sum_8bit_2),
            .out(out)
        );
    endmodule
endmodule