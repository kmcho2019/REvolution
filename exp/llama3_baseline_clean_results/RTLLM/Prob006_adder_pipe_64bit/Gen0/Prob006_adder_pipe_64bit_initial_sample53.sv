module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] stage1_a, stage1_b;
reg [63:0] stage2_a, stage2_b;
reg [7:0] stage1_sum [7:0];
reg [7:0] stage2_sum [7:0];
reg [7:0] stage3_sum [7:0];
reg [7:0] stage4_sum [7:0];
reg [7:0] stage5_sum [7:0];
reg [7:0] stage6_sum [7:0];
reg [7:0] stage7_sum [7:0];
reg [7:0] stage8_sum [7:0];
reg [7:0] carry [7:0];
reg i_en_reg, i_en_reg2, i_en_reg3, o_en_reg;
reg [64:0] result_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        stage2_a <= 64'd0;
        stage2_b <= 64'd0;
        i_en_reg <= 1'b0;
        i_en_reg2 <= 1'b0;
        i_en_reg3 <= 1'b0;
        o_en_reg <= 1'b0;
        result_reg <= 65'd0;
        for (int i = 0; i < 8; i++) begin
            stage1_sum[i] <= 8'd0;
            stage2_sum[i] <= 8'd0;
            stage3_sum[i] <= 8'd0;
            stage4_sum[i] <= 8'd0;
            stage5_sum[i] <= 8'd0;
            stage6_sum[i] <= 8'd0;
            stage7_sum[i] <= 8'd0;
            stage8_sum[i] <= 8'd0;
            carry[i] <= 1'b0;
        end
    end else if (i_en) begin
        stage1_a <= adda;
        stage1_b <= addb;
        i_en_reg <= 1'b1;
    end else begin
        stage1_a <= stage1_a;
        stage1_b <= stage1_b;
        i_en_reg <= i_en_reg;
    end
end

always @(posedge clk) begin
    if (i_en_reg) begin
        for (int i = 0; i < 8; i++) begin
            stage1_sum[i] <= stage1_a[i*8 +: 8] + stage1_b[i*8 +: 8];
            carry[i] <= (stage1_a[i*8 +: 8] + stage1_b[i*8 +: 8]) >= 256;
        end
        i_en_reg2 <= 1'b1;
    end else begin
        stage1_sum <= stage1_sum;
        carry <= carry;
        i_en_reg2 <= i_en_reg2;
    end
end

always @(posedge clk) begin
    if (i_en_reg2) begin
        for (int i = 0; i < 8; i++) begin
            if (i == 0) begin
                stage2_sum[i] <= stage1_sum[i] + {8'd0, carry[i]};
            end else begin
                stage2_sum[i] <= stage1_sum[i] + {8'd0, carry[i-1]};
            end
            carry[i] <= (stage1_sum[i] + {8'd0, carry[i]}) >= 256;
        end
        i_en_reg3 <= 1'b1;
    end else begin
        stage2_sum <= stage2_sum;
        carry <= carry;
        i_en_reg3 <= i_en_reg3;
    end
end

always @(posedge clk) begin
    if (i_en_reg3) begin
        for (int i = 0; i < 8; i++) begin
            if (i == 0) begin
                stage3_sum[i] <= stage2_sum[i] + {8'd0, carry[i]};
            end else begin
                stage3_sum[i] <= stage2_sum[i] + {8'd0, carry[i-1]};
            end
            carry[i] <= (stage2_sum[i] + {8'd0, carry[i]}) >= 256;
        end
    end else begin
        stage3_sum <= stage3_sum;
        carry <= carry;
    end
end

always @(posedge clk) begin
    if (i_en_reg3) begin
        for (int i = 0; i < 8; i++) begin
            if (i == 0) begin
                stage4_sum[i] <= stage3_sum[i] + {8'd0, carry[i]};
            end else begin
                stage4_sum[i] <= stage3_sum[i] + {8'd0, carry[i-1]};
            end
            carry[i] <= (stage3_sum[i] + {8'd0, carry[i]}) >= 256;
        end
    end else begin
        stage4_sum <= stage4_sum;
        carry <= carry;
    end
end

always @(posedge clk) begin
    if (i_en_reg3) begin
        for (int i = 0; i < 8; i++) begin
            if (i == 0) begin
                stage5_sum[i] <= stage4_sum[i] + {8'd0, carry[i]};
            end else begin
                stage5_sum[i] <= stage4_sum[i] + {8'd0, carry[i-1]};
            end
            carry[i] <= (stage4_sum[i] + {8'd0, carry[i]}) >= 256;
        end
    end else begin
        stage5_sum <= stage5_sum;
        carry <= carry;
    end
end

always @(posedge clk) begin
    if (i_en_reg3) begin
        for (int i = 0; i < 8; i++) begin
            if (i == 0) begin
                stage6_sum[i] <= stage5_sum[i] + {8'd0, carry[i]};
            end else begin
                stage6_sum[i] <= stage5_sum[i] + {8'd0, carry[i-1]};
            end
            carry[i] <= (stage5_sum[i] + {8'd0, carry[i]}) >= 256;
        end
    end else begin
        stage6_sum <= stage6_sum;
        carry <= carry;
    end
end

always @(posedge clk) begin
    if (i_en_reg3) begin
        for (int i = 0; i < 8; i++) begin
            if (i == 0) begin
                stage7_sum[i] <= stage6_sum[i] + {8'd0, carry[i]};
            end else begin
                stage7_sum[i] <= stage6_sum[i] + {8'd0, carry[i-1]};
            end
            carry[i] <= (stage6_sum[i] + {8'd0, carry[i]}) >= 256;
        end
    end else begin
        stage7_sum <= stage7_sum;
        carry <= carry;
    end
end

always @(posedge clk) begin
    if (i_en_reg3) begin
        for (int i = 0; i < 8; i++) begin
            if (i == 0) begin
                stage8_sum[i] <= stage7_sum[i] + {8'd0, carry[i]};
            end else begin
                stage8_sum[i] <= stage7_sum[i] + {8'd0, carry[i-1]};
            end
            carry[i] <= (stage7_sum[i] + {8'd0, carry[i]}) >= 256;
        end
        result_reg <= {carry[7], stage8_sum[7], stage8_sum[6], stage8_sum[5], stage8_sum[4], stage8_sum[3], stage8_sum[2], stage8_sum[1], stage8_sum[0]};
        o_en_reg <= 1'b1;
    end else begin
        stage8_sum <= stage8_sum;
        carry <= carry;
        result_reg <= result_reg;
        o_en_reg <= o_en_reg;
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule