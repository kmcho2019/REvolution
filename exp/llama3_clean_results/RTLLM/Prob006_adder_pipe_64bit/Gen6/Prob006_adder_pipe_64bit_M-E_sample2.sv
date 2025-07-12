module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Segment division
reg [15:0] seg_a [3:0];
reg [15:0] seg_b [3:0];
reg [16:0] seg_sum [3:0];

// Carry propagation
reg [0:0] carry [3:0];

// Pipeline stages
reg [64:0] out_result;
reg o_en_reg;

assign result = out_result;
assign o_en = o_en_reg;

// Segment division
always @ (*) begin
    seg_a[0] = adda[15:0];
    seg_a[1] = adda[31:16];
    seg_a[2] = adda[47:32];
    seg_a[3] = adda[63:48];

    seg_b[0] = addb[15:0];
    seg_b[1] = addb[31:16];
    seg_b[2] = addb[47:32];
    seg_b[3] = addb[63:48];
end

// Parallel addition and carry propagation
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < 4; i++) begin
            seg_sum[i] <= 17'd0;
            carry[i] <= 1'b0;
        end
        out_result <= 65'd0;
        o_en_reg <= 1'b0;
    end else begin
        if (i_en) begin
            // Segment 0
            seg_sum[0] <= {1'b0, seg_a[0]} + {1'b0, seg_b[0]};

            // Segments 1 to 3 with carry propagation
            for (int i = 1; i < 4; i++) begin
                seg_sum[i] <= {1'b0, seg_a[i]} + {1'b0, seg_b[i]} + {16'b0, carry[i-1]};
            end

            carry[0] <= seg_sum[0][16];
            for (int i = 1; i < 4; i++) begin
                carry[i] <= seg_sum[i][16];
            end

            out_result <= {carry[3], seg_sum[3][15:0], seg_sum[2][15:0], seg_sum[1][15:0], seg_sum[0][15:0]};
            o_en_reg <= i_en;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

endmodule