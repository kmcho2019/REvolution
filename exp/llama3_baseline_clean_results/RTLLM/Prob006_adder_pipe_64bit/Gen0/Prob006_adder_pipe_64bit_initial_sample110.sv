module adder_pipe_64bit (
    input           clk, 
    input           rst_n, 
    input           i_en, 
    input   [63:0]  adda, 
    input   [63:0]  addb, 
    output  [64:0]  result, 
    output          o_en
);

reg   [63:0]  stage1_adda;
reg   [63:0]  stage1_addb;
reg           stage1_i_en;

reg   [63:0]  stage2_adda;
reg   [63:0]  stage2_addb;
reg           stage2_i_en;

reg   [64:0]  stage3_result;
reg           stage3_o_en;

// Pipeline stage 1
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_adda  <= 64'd0;
        stage1_addb  <= 64'd0;
        stage1_i_en  <= 1'd0;
    end else if (i_en) begin
        stage1_adda  <= adda;
        stage1_addb  <= addb;
        stage1_i_en  <= 1'd1;
    end else begin
        stage1_adda  <= stage1_adda;
        stage1_addb  <= stage1_addb;
        stage1_i_en  <= stage1_i_en;
    end
end

// Pipeline stage 2
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_adda  <= 64'd0;
        stage2_addb  <= 64'd0;
        stage2_i_en  <= 1'd0;
    end else if (stage1_i_en) begin
        stage2_adda  <= stage1_adda;
        stage2_addb  <= stage1_addb;
        stage2_i_en  <= stage1_i_en;
    end else begin
        stage2_adda  <= stage2_adda;
        stage2_addb  <= stage2_addb;
        stage2_i_en  <= stage2_i_en;
    end
end

// Pipeline stage 3 (ripple carry adder)
reg   [63:0]  sum;
reg   [63:0]  carry;

always @(*) begin
    sum  = 64'd0;
    carry = 64'd0;
    for (int i = 0; i < 64; i++) begin
        reg  temp_sum;
        reg  temp_carry;
        if (i == 0) begin
            temp_sum = stage2_adda[i] ^ stage2_addb[i];
            temp_carry = stage2_adda[i] & stage2_addb[i];
        end else begin
            temp_sum = sum[i-1] ^ stage2_addb[i] ^ carry[i-1];
            temp_carry = (sum[i-1] & stage2_addb[i]) | (sum[i-1] & carry[i-1]) | (stage2_addb[i] & carry[i-1]);
        end
        sum[i] = temp_sum;
        carry[i] = temp_carry;
    end
    stage3_result = {carry[63], sum};
end

// Output stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage3_o_en  <= 1'd0;
        o_en  <= 1'd0;
        result <= 65'd0;
    end else if (stage2_i_en) begin
        stage3_o_en  <= stage2_i_en;
        o_en  <= stage2_i_en;
        result <= stage3_result;
    end else begin
        stage3_o_en  <= stage3_o_en;
        o_en  <= stage3_o_en;
        result <= result;
    end
end

endmodule