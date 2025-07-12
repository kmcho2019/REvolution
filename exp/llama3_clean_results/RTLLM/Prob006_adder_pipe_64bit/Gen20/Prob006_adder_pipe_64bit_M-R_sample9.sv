module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);

    assign sum = a + b + cin;
    assign cout = (a[15] & b[15]) | (a[15] & cin) | (b[15] & cin);

endmodule

module pipeline_stage(
    input [15:0] sum_in,
    input cin_in,
    output [15:0] sum_out,
    output cout_out
);

    assign sum_out = sum_in;
    assign cout_out = cin_in;

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

    reg [1:0] state;
    wire [15:0] sum1, sum2, sum3, sum4;
    wire cout1, cout2, cout3, cout4;
    reg [15:0] sum1_reg, sum2_reg, sum3_reg, sum4_reg;
    reg cout1_reg, cout2_reg, cout3_reg, cout4_reg;

    adder_16bit u1(
       .a(adda[15:0]),
       .b(addb[15:0]),
       .cin(1'b0),
       .sum(sum1),
       .cout(cout1)
    );

    pipeline_stage u2(
       .sum_in(sum1),
       .cin_in(cout1),
       .sum_out(sum1_reg),
       .cout_out(cout1_reg)
    );

    adder_16bit u3(
       .a(adda[31:16]),
       .b(addb[31:16]),
       .cin(cout1_reg),
       .sum(sum2),
       .cout(cout2)
    );

    pipeline_stage u4(
       .sum_in(sum2),
       .cin_in(cout2),
       .sum_out(sum2_reg),
       .cout_out(cout2_reg)
    );

    adder_16bit u5(
       .a(adda[47:32]),
       .b(addb[47:32]),
       .cin(cout2_reg),
       .sum(sum3),
       .cout(cout3)
    );

    pipeline_stage u6(
       .sum_in(sum3),
       .cin_in(cout3),
       .sum_out(sum3_reg),
       .cout_out(cout3_reg)
    );

    adder_16bit u7(
       .a(adda[63:48]),
       .b(addb[63:48]),
       .cin(cout3_reg),
       .sum(sum4),
       .cout(cout4)
    );

    pipeline_stage u8(
       .sum_in(sum4),
       .cin_in(cout4),
       .sum_out(sum4_reg),
       .cout_out(cout4_reg)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'd0;
            o_en <= 1'b0;
        end else begin
            case (state)
                2'd0: begin
                    if (i_en) begin
                        state <= 2'd1;
                    end else begin
                        state <= 2'd0;
                    end
                end
                2'd1: begin
                    state <= 2'd2;
                end
                2'd2: begin
                    o_en <= 1'b1;
                    state <= 2'd0;
                end
            endcase
        end
    end

    assign result = {cout4_reg, sum4_reg, sum3_reg, sum2_reg, sum1_reg};

endmodule

module clock_gen(
    output reg clk
);

    always #50 clk = ~clk;

endmodule

module testbench;
    reg rst_n;
    reg i_en;
    reg [63:0] adda;
    reg [63:0] addb;
    wire [64:0] result;
    wire o_en;
    wire clk;

    clock_gen u1(
       .clk(clk)
    );

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
        #400;
        i_en = 1'b0;
        #100;
        $finish;
    end

endmodule