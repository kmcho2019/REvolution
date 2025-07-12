module sub_64bit (
    input clk,
    input enable,
    input [63:0] A,
    input [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    // Pipeline registers
    reg [63:0] stage1_result;
    reg stage1_A_sign, stage1_B_sign;
    wire [63:0] diff = A - B;
    
    // Clock gating
    wire gated_clk;
    assign gated_clk = clk & enable;

    // Carry-select adder implementation (4x16-bit chunks)
    wire [15:0] diff0, diff1, diff2, diff3;
    wire cout0, cout1, cout2;
    
    // Stage 1: 4x16-bit parallel subtractions
    carry_select_16bit sub0 (.A(A[15:0]), .B(B[15:0]), .cin(1'b1), .sum(diff0), .cout(cout0));
    carry_select_16bit sub1 (.A(A[31:16]), .B(B[31:16]), .cin(cout0), .sum(diff1), .cout(cout1));
    carry_select_16bit sub2 (.A(A[47:32]), .B(B[47:32]), .cin(cout1), .sum(diff2), .cout(cout2));
    carry_select_16bit sub3 (.A(A[63:48]), .B(B[63:48]), .cin(cout2), .sum(diff3), .cout());

    // Pipeline stage 1
    always @(posedge gated_clk) begin
        stage1_result <= {diff3, diff2, diff1, diff0};
        stage1_A_sign <= A[63];
        stage1_B_sign <= B[63];
    end

    // Pipeline stage 2 (overflow detection)
    always @(posedge gated_clk) begin
        result <= stage1_result;
        overflow <= (stage1_A_sign != stage1_B_sign) && (stage1_A_sign != stage1_result[63]);
    end

endmodule

// 16-bit carry-select subtractor module
module carry_select_16bit (
    input [15:0] A,
    input [15:0] B,
    input cin,
    output [15:0] sum,
    output cout
);
    wire [15:0] B_comp = ~B;
    wire [7:0] sum_low0, sum_low1;
    wire [7:0] sum_high0, sum_high1;
    wire cout_low0, cout_low1;
    wire cout_mid;
    
    // Lower 8 bits with carry=0 and carry=1
    adder_8bit adder_low0 (.A(A[7:0]), .B(B_comp[7:0]), .cin(1'b0), .sum(sum_low0), .cout(cout_low0));
    adder_8bit adder_low1 (.A(A[7:0]), .B(B_comp[7:0]), .cin(1'b1), .sum(sum_low1), .cout(cout_low1));
    
    // Select lower 8-bit result
    wire [7:0] sum_low = cin ? sum_low1 : sum_low0;
    wire carry_mid = cin ? cout_low1 : cout_low0;
    
    // Upper 8 bits with carry=0 and carry=1
    adder_8bit adder_high0 (.A(A[15:8]), .B(B_comp[15:8]), .cin(1'b0), .sum(sum_high0), .cout(cout_high0));
    adder_8bit adder_high1 (.A(A[15:8]), .B(B_comp[15:8]), .cin(1'b1), .sum(sum_high1), .cout(cout_high1));
    
    // Select upper 8-bit result
    wire [7:0] sum_high = carry_mid ? sum_high1 : sum_high0;
    assign cout = carry_mid ? cout_high1 : cout_high0;
    
    assign sum = {sum_high, sum_low};
endmodule

// Basic 8-bit adder
module adder_8bit (
    input [7:0] A,
    input [7:0] B,
    input cin,
    output [7:0] sum,
    output cout
);
    assign {cout, sum} = A + B + cin;
endmodule