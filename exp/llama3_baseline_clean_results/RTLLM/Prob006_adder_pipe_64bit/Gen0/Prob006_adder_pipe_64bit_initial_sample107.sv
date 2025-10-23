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
reg stage1_en;

reg [63:0] stage2_adda;
reg [63:0] stage2_addb;
reg stage2_en;

reg [64:0] sum;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
        stage1_en <= 1'b0;
        stage2_adda <= 64'd0;
        stage2_addb <= 64'd0;
        stage2_en <= 1'b0;
        result <= 65'd0;
        o_en <= 1'b0;
    end else begin
        if (i_en) begin
            stage1_adda <= adda;
            stage1_addb <= addb;
            stage1_en <= 1'b1;
        end else begin
            stage1_adda <= stage1_adda;
            stage1_addb <= stage1_addb;
            stage1_en <= stage1_en;
        end
        
        if (stage1_en) begin
            stage2_adda <= stage1_adda;
            stage2_addb <= stage1_addb;
            stage2_en <= 1'b1;
        end else begin
            stage2_adda <= stage2_adda;
            stage2_addb <= stage2_addb;
            stage2_en <= stage2_en;
        end
        
        if (stage2_en) begin
            sum <= {1'b0, stage2_adda} + {1'b0, stage2_addb};
            result <= sum;
            o_en <= 1'b1;
        end else begin
            result <= result;
            o_en <= o_en;
        end
    end
end

endmodule