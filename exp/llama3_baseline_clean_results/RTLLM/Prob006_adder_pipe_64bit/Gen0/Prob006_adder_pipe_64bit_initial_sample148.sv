module adder_pipe_64bit(
    input               clk,
    input               rst_n,
    input               i_en,
    input  [63:0]       adda,
    input  [63:0]       addb,
    output reg [64:0]   result,
    output reg           o_en
);

reg [63:0]           stage1_sum;
reg [63:0]           stage2_sum;
reg [0:0]            stage1_cout;
reg [0:0]            stage2_cout;
reg                  stage1_en;
reg                  stage2_en;
reg                  stage3_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_en      <= 1'b0;
        stage2_en      <= 1'b0;
        stage3_en      <= 1'b0;
        stage1_sum     <= 64'd0;
        stage2_sum     <= 64'd0;
        stage1_cout    <= 1'b0;
        stage2_cout    <= 1'b0;
        result         <= 65'd0;
        o_en           <= 1'b0;
    end else begin
        stage1_en      <= i_en;
        stage2_en      <= stage1_en;
        stage3_en      <= stage2_en;
        
        if (stage1_en) begin
            stage1_sum     <= adda[63:0] + addb[63:0];
            stage1_cout    <= (adda[63:0] + addb[63:0]) > 64'd0;
        end else begin
            stage1_sum     <= 64'd0;
            stage1_cout    <= 1'b0;
        end
        
        if (stage2_en) begin
            stage2_sum     <= stage1_sum + {{63{stage1_cout}}, stage1_cout};
            stage2_cout    <= (stage1_sum + {{63{stage1_cout}}, stage1_cout}) > 64'd0;
        end else begin
            stage2_sum     <= 64'd0;
            stage2_cout    <= 1'b0;
        end
        
        if (stage3_en) begin
            result         <= {stage2_cout, stage2_sum};
            o_en           <= 1'b1;
        end else begin
            result         <= 65'd0;
            o_en           <= 1'b0;
        end
    end
end

endmodule