module adder_pipe_64bit(
    input  clk,
    input  rst_n,
    input  i_en,
    input  [63:0] adda,
    input  [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_reg1, adda_reg2, adda_reg3, adda_reg4;
reg [63:0] addb_reg1, addb_reg2, addb_reg3, addb_reg4;
reg i_en_reg1, i_en_reg2, i_en_reg3, i_en_reg4;
reg [15:0] sum1, sum2, sum3, sum4;
reg c_out1, c_out2, c_out3;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg1 <= 64'd0;
        addb_reg1 <= 64'd0;
        i_en_reg1 <= 1'b0;
    end else if (i_en) begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= 1'b1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg2 <= 64'd0;
        addb_reg2 <= 64'd0;
        i_en_reg2 <= 1'b0;
    end else begin
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        i_en_reg2 <= i_en_reg1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum1 <= 16'd0;
        c_out1 <= 1'b0;
        adda_reg3 <= 64'd0;
        addb_reg3 <= 64'd0;
        i_en_reg3 <= 1'b0;
    end else if (i_en_reg2) begin
        {c_out1, sum1} = adda_reg2[15:0] + addb_reg2[15:0];
        adda_reg3 <= adda_reg2;
        addb_reg3 <= addb_reg2;
        i_en_reg3 <= i_en_reg2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum2 <= 16'd0;
        c_out2 <= 1'b0;
        adda_reg4 <= 64'd0;
        addb_reg4 <= 64'd0;
        i_en_reg4 <= 1'b0;
    end else if (i_en_reg3) begin
        {c_out2, sum2} = adda_reg3[31:16] + addb_reg3[31:16] + c_out1;
        adda_reg4 <= adda_reg3;
        addb_reg4 <= addb_reg3;
        i_en_reg4 <= i_en_reg3;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum3 <= 16'd0;
        c_out3 <= 1'b0;
    end else if (i_en_reg4) begin
        {c_out3, sum3} = adda_reg4[47:32] + addb_reg4[47:32] + c_out2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum4 <= 16'd0;
        result <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en_reg4) begin
        {result[64], result[63:48]} = adda_reg4[63:48] + addb_reg4[63:48] + c_out3;
        result[47:0] = {sum3, sum2, sum1};
        o_en <= i_en_reg4;
    end
end

endmodule