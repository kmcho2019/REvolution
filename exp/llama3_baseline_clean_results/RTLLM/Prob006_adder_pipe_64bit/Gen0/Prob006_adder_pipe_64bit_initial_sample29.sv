module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] stage1_adda;
reg [63:0] stage1_addb;
reg stage1_i_en;
reg [63:0] stage2_sum;
reg stage2_cout;
reg stage2_i_en;
reg [64:0] stage3_result;
reg stage3_i_en;

// Stage 1: Input Register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
        stage1_i_en <= 1'b0;
    end else if (i_en) begin
        stage1_adda <= adda;
        stage1_addb <= addb;
        stage1_i_en <= 1'b1;
    end
end

// Stage 2: Ripple Carry Adder
reg [63:0] sum;
reg [63:0] carry;
always @(*) begin
    sum = stage1_adda + stage1_addb;
    carry = (stage1_adda & stage1_addb) | (stage1_adda & {64{sum[63]}}) | (stage1_addb & {64{sum[63]}});
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_sum <= 64'd0;
        stage2_cout <= 1'b0;
        stage2_i_en <= 1'b0;
    end else if (stage1_i_en) begin
        stage2_sum <= sum;
        stage2_cout <= carry[63];
        stage2_i_en <= 1'b1;
    end
end

// Stage 3: Output Register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage3_result <= 65'd0;
        stage3_i_en <= 1'b0;
        o_en <= 1'b0;
    end else if (stage2_i_en) begin
        stage3_result <= {1'b0, stage2_sum} + {64'd0, stage2_cout};
        stage3_i_en <= 1'b1;
        if (stage2_i_en) begin
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end else begin
        o_en <= 1'b0;
    end
end

// Final Output
always @(posedge clk) begin
    result <= stage3_result;
end

endmodule