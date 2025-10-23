module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Internal signals
reg [63:0] stage1_a;
reg [63:0] stage1_b;
reg stage1_en;
reg [64:0] stage1_result;

reg [63:0] stage2_a;
reg [63:0] stage2_b;
reg stage2_en;
reg [64:0] stage2_result;

reg [64:0] final_result;
reg o_en_reg;

// 1-bit full adder module
module full_adder(
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
module ripple_carry_adder(
    input [63:0] a,
    input [63:0] b,
    output [64:0] result
);
    wire [63:0] cout;
    assign result[0] = a[0] ^ b[0];
    assign cout[0] = a[0] & b[0];

    full_adder fa[63:1] (.a(a[63:1]),.b(b[63:1]),.cin(cout[62:0]),.sum(result[63:1]),.cout(cout[63:1]));
    assign result[64] = cout[63];
endmodule

// Pipeline stage 1
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        stage1_en <= 1'd0;
    end else if (i_en) begin
        stage1_a <= adda;
        stage1_b <= addb;
        stage1_en <= 1'd1;
    end else begin
        stage1_a <= stage1_a;
        stage1_b <= stage1_b;
        stage1_en <= stage1_en;
    end
end

ripple_carry_adder stage1_adder (.a(stage1_a),.b(stage1_b),.result(stage1_result));

// Pipeline stage 2
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_a <= 64'd0;
        stage2_b <= 64'd0;
        stage2_en <= 1'd0;
        stage2_result <= 65'd0;
    end else if (stage1_en) begin
        stage2_a <= stage1_a;
        stage2_b <= stage1_b;
        stage2_en <= 1'd1;
        stage2_result <= stage1_result;
    end else begin
        stage2_a <= stage2_a;
        stage2_b <= stage2_b;
        stage2_en <= stage2_en;
        stage2_result <= stage2_result;
    end
end

// Output stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        final_result <= 65'd0;
        o_en_reg <= 1'd0;
    end else if (stage2_en) begin
        final_result <= stage2_result;
        o_en_reg <= 1'd1;
    end else begin
        final_result <= final_result;
        o_en_reg <= o_en_reg;
    end
end

assign result = final_result;
assign o_en = o_en_reg;

endmodule