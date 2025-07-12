module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

reg [7:0] segment0_a, segment0_b;
reg [7:0] segment1_a, segment1_b;
reg [7:0] segment2_a, segment2_b;
reg [7:0] segment3_a, segment3_b;
reg [7:0] segment4_a, segment4_b;
reg [7:0] segment5_a, segment5_b;
reg [7:0] segment6_a, segment6_b;
reg [7:0] segment7_a, segment7_b;

reg [8:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        segment0_a <= 8'd0;
        segment0_b <= 8'd0;
        segment1_a <= 8'd0;
        segment1_b <= 8'd0;
        segment2_a <= 8'd0;
        segment2_b <= 8'd0;
        segment3_a <= 8'd0;
        segment3_b <= 8'd0;
        segment4_a <= 8'd0;
        segment4_b <= 8'd0;
        segment5_a <= 8'd0;
        segment5_b <= 8'd0;
        segment6_a <= 8'd0;
        segment6_b <= 8'd0;
        segment7_a <= 8'd0;
        segment7_b <= 8'd0;
        o_en <= 1'b0;
    end else if (i_en) begin
        segment0_a <= adda[7:0];
        segment0_b <= addb[7:0];
        segment1_a <= adda[15:8];
        segment1_b <= addb[15:8];
        segment2_a <= adda[23:16];
        segment2_b <= addb[23:16];
        segment3_a <= adda[31:24];
        segment3_b <= addb[31:24];
        segment4_a <= adda[39:32];
        segment4_b <= addb[39:32];
        segment5_a <= adda[47:40];
        segment5_b <= addb[47:40];
        segment6_a <= adda[55:48];
        segment6_b <= addb[55:48];
        segment7_a <= adda[63:56];
        segment7_b <= addb[63:56];
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

always @(posedge clk) begin
    sum0 <= {1'b0, segment0_a} + {1'b0, segment0_b};
    sum1 <= {1'b0, segment1_a} + {1'b0, segment1_b} + {sum0[8], 8'b0};
    sum2 <= {1'b0, segment2_a} + {1'b0, segment2_b} + {sum1[8], 8'b0};
    sum3 <= {1'b0, segment3_a} + {1'b0, segment3_b} + {sum2[8], 8'b0};
    sum4 <= {1'b0, segment4_a} + {1'b0, segment4_b} + {sum3[8], 8'b0};
    sum5 <= {1'b0, segment5_a} + {1'b0, segment5_b} + {sum4[8], 8'b0};
    sum6 <= {1'b0, segment6_a} + {1'b0, segment6_b} + {sum5[8], 8'b0};
    sum7 <= {1'b0, segment7_a} + {1'b0, segment7_b} + {sum6[8], 8'b0};
end

assign result[7:0] = sum0[7:0];
assign result[15:8] = sum1[7:0];
assign result[23:16] = sum2[7:0];
assign result[31:24] = sum3[7:0];
assign result[39:32] = sum4[7:0];
assign result[47:40] = sum5[7:0];
assign result[55:48] = sum6[7:0];
assign result[63:56] = sum7[7:0];
assign result[64] = sum7[8];

endmodule