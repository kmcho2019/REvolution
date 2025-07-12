// Define the full adder module
module full_adder(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [8:0] sum
);

assign sum[7:0] = a + b + cin;
assign sum[8] = (a[7] & b[7]) | (a[7] & cin) | (b[7] & cin);

endmodule

// Define the half adder module
module half_adder(
    input a,
    input b,
    output sum,
    output cout
);

assign sum = a ^ b;
assign cout = a & b;

endmodule

// Define the adder pipeline stage module
module adder_stage(
    input clk,
    input rst_n,
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [8:0] sum
);

reg [8:0] sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= 9'd0;
    end else begin
        sum_reg <= a + b + cin;
    end
end

assign sum = sum_reg;

endmodule

// Define the main adder module
module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

// Define the pipeline stages
reg [8:0] sum_stage0;
reg [8:0] sum_stage1;
reg [8:0] sum_stage2;
reg [8:0] sum_stage3;
reg [8:0] sum_stage4;
reg [8:0] sum_stage5;
reg [8:0] sum_stage6;
reg [8:0] sum_stage7;

// Define the carry signals
reg [7:0] carry;

// Define the output register
reg [64:0] result_reg;

// Initialize the output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result_reg <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en) begin
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

// Define the adder pipeline stages
adder_stage stage0(
   .clk(clk),
   .rst_n(rst_n),
   .a(adda[7:0]),
   .b(addb[7:0]),
   .cin(1'b0),
   .sum(sum_stage0)
);

adder_stage stage1(
   .clk(clk),
   .rst_n(rst_n),
   .a(adda[15:8]),
   .b(addb[15:8]),
   .cin(sum_stage0[8]),
   .sum(sum_stage1)
);

adder_stage stage2(
   .clk(clk),
   .rst_n(rst_n),
   .a(adda[23:16]),
   .b(addb[23:16]),
   .cin(sum_stage1[8]),
   .sum(sum_stage2)
);

adder_stage stage3(
   .clk(clk),
   .rst_n(rst_n),
   .a(adda[31:24]),
   .b(addb[31:24]),
   .cin(sum_stage2[8]),
   .sum(sum_stage3)
);

adder_stage stage4(
   .clk(clk),
   .rst_n(rst_n),
   .a(adda[39:32]),
   .b(addb[39:32]),
   .cin(sum_stage3[8]),
   .sum(sum_stage4)
);

adder_stage stage5(
   .clk(clk),
   .rst_n(rst_n),
   .a(adda[47:40]),
   .b(addb[47:40]),
   .cin(sum_stage4[8]),
   .sum(sum_stage5)
);

adder_stage stage6(
   .clk(clk),
   .rst_n(rst_n),
   .a(adda[55:48]),
   .b(addb[55:48]),
   .cin(sum_stage5[8]),
   .sum(sum_stage6)
);

adder_stage stage7(
   .clk(clk),
   .rst_n(rst_n),
   .a(adda[63:56]),
   .b(addb[63:56]),
   .cin(sum_stage6[8]),
   .sum(sum_stage7)
);

// Update the result register
always @(posedge clk) begin
    result_reg[7:0] <= sum_stage0[7:0];
    result_reg[15:8] <= sum_stage1[7:0];
    result_reg[23:16] <= sum_stage2[7:0];
    result_reg[31:24] <= sum_stage3[7:0];
    result_reg[39:32] <= sum_stage4[7:0];
    result_reg[47:40] <= sum_stage5[7:0];
    result_reg[55:48] <= sum_stage6[7:0];
    result_reg[63:56] <= sum_stage7[7:0];
    result_reg[64] <= sum_stage7[8];
end

// Assign the output
assign result = result_reg;

endmodule