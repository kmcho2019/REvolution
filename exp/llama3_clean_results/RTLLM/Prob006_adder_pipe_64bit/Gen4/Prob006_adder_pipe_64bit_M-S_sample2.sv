module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [15:0] seg_adda [3:0];
reg [15:0] seg_addb [3:0];
reg [16:0] seg_result [3:0];
reg [64:0] out_result;
reg o_en_reg;

assign result = out_result;
assign o_en = o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out_result <= 65'd0;
        o_en_reg <= 1'b0;
        for (int i = 0; i < 4; i++) begin
            seg_adda[i] <= 16'd0;
            seg_addb[i] <= 16'd0;
            seg_result[i] <= 17'd0;
        end
    end else begin
        if (i_en) begin
            seg_adda[0] <= adda[15:0];
            seg_addb[0] <= addb[15:0];
            seg_adda[1] <= adda[31:16];
            seg_addb[1] <= addb[31:16];
            seg_adda[2] <= adda[47:32];
            seg_addb[2] <= addb[47:32];
            seg_adda[3] <= adda[63:48];
            seg_addb[3] <= addb[63:48];
        end

        seg_result[0] <= {1'b0, seg_adda[0]} + {1'b0, seg_addb[0]};
        for (int i = 1; i < 4; i++) begin
            seg_result[i] <= {1'b0, seg_adda[i]} + {1'b0, seg_addb[i]} + {16'b0, seg_result[i-1][16]};
        end

        out_result <= {seg_result[3][16], seg_result[3][15:0], seg_result[2][15:0], seg_result[1][15:0], seg_result[0][15:0]};
        o_en_reg <= i_en;
    end
end

endmodule