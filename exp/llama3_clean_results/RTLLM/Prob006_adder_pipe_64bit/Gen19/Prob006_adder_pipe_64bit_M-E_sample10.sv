module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    assign sum = a + b + cin;
    assign cout = (a[7] & b[7]) | (a[7] & cin) | (b[7] & cin);

endmodule

module pipeline_stage(
    input clk,
    input rst_n,
    input [7:0] sum_in,
    input cin_in,
    output [7:0] sum_out,
    output cout_out
);

    reg [7:0] sum_reg;
    reg cout_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= 8'd0;
            cout_reg <= 1'b0;
        end else begin
            sum_reg <= sum_in;
            cout_reg <= cin_in;
        end
    end

    assign sum_out = sum_reg;
    assign cout_out = cout_reg;

endmodule

module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

    wire [7:0] sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8;
    wire cout1, cout2, cout3, cout4, cout5, cout6, cout7, cout8;
    reg [7:0] sum1_reg, sum2_reg, sum3_reg, sum4_reg, sum5_reg, sum6_reg, sum7_reg, sum8_reg;
    reg cout1_reg, cout2_reg, cout3_reg, cout4_reg, cout5_reg, cout6_reg, cout7_reg, cout8_reg;
    reg [7:0] sum_out1, sum_out2, sum_out3, sum_out4, sum_out5, sum_out6, sum_out7, sum_out8;
    reg cout_out1, cout_out2, cout_out3, cout_out4, cout_out5, cout_out6, cout_out7, cout_out8;
    reg i_en_reg;

    adder_8bit u1(
       .a(adda[7:0]),
       .b(addb[7:0]),
       .cin(1'b0),
       .sum(sum1),
       .cout(cout1)
    );

    pipeline_stage u2(
       .clk(clk),
       .rst_n(rst_n),
       .sum_in(sum1),
       .cin_in(cout1),
       .sum_out(sum_out1),
       .cout_out(cout_out1)
    );

    adder_8bit u3(
       .a(adda[15:8]),
       .b(addb[15:8]),
       .cin(cout_out1),
       .sum(sum2),
       .cout(cout2)
    );

    pipeline_stage u4(
       .clk(clk),
       .rst_n(rst_n),
       .sum_in(sum2),
       .cin_in(cout2),
       .sum_out(sum_out2),
       .cout_out(cout_out2)
    );

    adder_8bit u5(
       .a(adda[23:16]),
       .b(addb[23:16]),
       .cin(cout_out2),
       .sum(sum3),
       .cout(cout3)
    );

    pipeline_stage u6(
       .clk(clk),
       .rst_n(rst_n),
       .sum_in(sum3),
       .cin_in(cout3),
       .sum_out(sum_out3),
       .cout_out(cout_out3)
    );

    adder_8bit u7(
       .a(adda[31:24]),
       .b(addb[31:24]),
       .cin(cout_out3),
       .sum(sum4),
       .cout(cout4)
    );

    pipeline_stage u8(
       .clk(clk),
       .rst_n(rst_n),
       .sum_in(sum4),
       .cin_in(cout4),
       .sum_out(sum_out4),
       .cout_out(cout_out4)
    );

    adder_8bit u9(
       .a(adda[39:32]),
       .b(addb[39:32]),
       .cin(cout_out4),
       .sum(sum5),
       .cout(cout5)
    );

    pipeline_stage u10(
       .clk(clk),
       .rst_n(rst_n),
       .sum_in(sum5),
       .cin_in(cout5),
       .sum_out(sum_out5),
       .cout_out(cout_out5)
    );

    adder_8bit u11(
       .a(adda[47:40]),
       .b(addb[47:40]),
       .cin(cout_out5),
       .sum(sum6),
       .cout(cout6)
    );

    pipeline_stage u12(
       .clk(clk),
       .rst_n(rst_n),
       .sum_in(sum6),
       .cin_in(cout6),
       .sum_out(sum_out6),
       .cout_out(cout_out6)
    );

    adder_8bit u13(
       .a(adda[55:48]),
       .b(addb[55:48]),
       .cin(cout_out6),
       .sum(sum7),
       .cout(cout7)
    );

    pipeline_stage u14(
       .clk(clk),
       .rst_n(rst_n),
       .sum_in(sum7),
       .cin_in(cout7),
       .sum_out(sum_out7),
       .cout_out(cout_out7)
    );

    adder_8bit u15(
       .a(adda[63:56]),
       .b(addb[63:56]),
       .cin(cout_out7),
       .sum(sum8),
       .cout(cout8)
    );

    pipeline_stage u16(
       .clk(clk),
       .rst_n(rst_n),
       .sum_in(sum8),
       .cin_in(cout8),
       .sum_out(sum_out8),
       .cout_out(cout_out8)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i_en_reg <= 1'b0;
            o_en <= 1'b0;
        end else begin
            i_en_reg <= i_en;
            if (i_en_reg) begin
                o_en <= 1'b1;
            end else begin
                o_en <= 1'b0;
            end
        end
    end

    assign result = {1'b0, sum_out8, sum_out7, sum_out6, sum_out5, sum_out4, sum_out3, sum_out2, sum_out1};

endmodule

module testbench;
    reg clk;
    reg rst_n;
    reg i_en;
    reg [63:0] adda;
    reg [63:0] addb;
    wire [64:0] result;
    wire o_en;

    adder_pipe_64bit uut(
       .clk(clk),
       .rst_n(rst_n),
       .i_en(i_en),
       .adda(adda),
       .addb(addb),
       .result(result),
       .o_en(o_en)
    );

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        i_en = 1'b0;
        adda = 64'd0;
        addb = 64'd0;
        #100;
        rst_n = 1'b1;
        #100;
        i_en = 1'b1;
        adda = 64'd100;
        addb = 64'd200;
        #100;
        i_en = 1'b0;
        #100;
        $finish;
    end

    always #50 clk = ~clk;

endmodule