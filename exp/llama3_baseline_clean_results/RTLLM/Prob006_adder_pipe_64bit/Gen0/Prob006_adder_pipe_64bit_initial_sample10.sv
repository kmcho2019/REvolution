module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] stage1_adda;
reg [63:0] stage1_addb;
reg stage1_i_en;

reg [63:0] stage2_adda;
reg [63:0] stage2_addb;
reg stage2_i_en;

reg [64:0] stage3_result;
reg stage3_o_en;

// Full adder module
module full_adder (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 64-bit ripple carry adder module
module ripple_carry_adder (
    input [63:0] a,
    input [63:0] b,
    output [64:0] sum
);
    wire [63:0] cout;
    full_adder fa0 (a[0], b[0], 1'b0, sum[0], cout[0]);
    genvar i;
    generate
        for (i = 1; i < 64; i++) begin
            full_adder fa (a[i], b[i], cout[i-1], sum[i], cout[i]);
        end
    endgenerate
    assign sum[64] = cout[63];
endmodule

// Pipeline stage 1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
        stage1_i_en <= 1'b0;
    end else if (i_en) begin
        stage1_adda <= adda;
        stage1_addb <= addb;
        stage1_i_en <= 1'b1;
    end else begin
        stage1_adda <= stage1_adda;
        stage1_addb <= stage1_addb;
        stage1_i_en <= stage1_i_en;
    end
end

// Pipeline stage 2
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_adda <= 64'd0;
        stage2_addb <= 64'd0;
        stage2_i_en <= 1'b0;
    end else if (stage1_i_en) begin
        stage2_adda <= stage1_adda;
        stage2_addb <= stage1_addb;
        stage2_i_en <= stage1_i_en;
    end else begin
        stage2_adda <= stage2_adda;
        stage2_addb <= stage2_addb;
        stage2_i_en <= stage2_i_en;
    end
end

// Pipeline stage 3
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage3_result <= 65'd0;
        stage3_o_en <= 1'b0;
    end else if (stage2_i_en) begin
        ripple_carry_adder rca (stage2_adda, stage2_addb, stage3_result);
        stage3_o_en <= stage2_i_en;
    end else begin
        stage3_result <= stage3_result;
        stage3_o_en <= stage3_o_en;
    end
end

assign result = stage3_result;
assign o_en = stage3_o_en;

endmodule