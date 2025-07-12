module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] stage1_sum;
reg [63:0] stage2_sum;
reg [63:0] stage3_sum;
reg [63:0] stage4_sum;
reg [0:0] stage1_cout;
reg [0:0] stage2_cout;
reg [0:0] stage3_cout;
reg [0:0] stage4_cout;
reg stage1_en;
reg stage2_en;
reg stage3_en;
reg stage4_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_sum <= 64'd0;
        stage1_cout <= 1'd0;
        stage2_sum <= 64'd0;
        stage2_cout <= 1'd0;
        stage3_sum <= 64'd0;
        stage3_cout <= 1'd0;
        stage4_sum <= 64'd0;
        stage4_cout <= 1'd0;
        stage1_en <= 1'd0;
        stage2_en <= 1'd0;
        stage3_en <= 1'd0;
        stage4_en <= 1'd0;
        o_en <= 1'd0;
    end else begin
        stage1_en <= i_en;
        stage2_en <= stage1_en;
        stage3_en <= stage2_en;
        stage4_en <= stage3_en;
        
        // stage 1
        stage1_sum <= adda[15:0] + addb[15:0];
        stage1_cout <= (adda[15:0] + addb[15:0] >= 16'd1) ? 1'd1 : 1'd0;
        
        // stage 2
        if (stage2_en) begin
            stage2_sum <= {adda[31:16], 16'd0} + {addb[31:16], 16'd0} + {16'd0, stage1_cout};
            stage2_cout <= ({adda[31:16], 16'd0} + {addb[31:16], 16'd0} + {16'd0, stage1_cout} >= 17'd1) ? 1'd1 : 1'd0;
        end
        
        // stage 3
        if (stage3_en) begin
            stage3_sum <= {adda[47:32], 16'd0} + {addb[47:32], 16'd0} + {16'd0, stage2_cout};
            stage3_cout <= ({adda[47:32], 16'd0} + {addb[47:32], 16'd0} + {16'd0, stage2_cout} >= 17'd1) ? 1'd1 : 1'd0;
        end
        
        // stage 4
        if (stage4_en) begin
            stage4_sum <= {adda[63:48], 16'd0} + {addb[63:48], 16'd0} + {16'd0, stage3_cout};
            stage4_cout <= ({adda[63:48], 16'd0} + {addb[63:48], 16'd0} + {16'd0, stage3_cout} >= 17'd1) ? 1'd1 : 1'd0;
            result <= {stage4_cout, stage4_sum};
        end
        
        o_en <= stage4_en;
    end
end

endmodule