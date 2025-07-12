module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input  [63:0]      adda,
    input  [63:0]      addb,
    output [64:0]      result,
    output              o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg [64:0] result_reg;
reg [63:0] sum [3:0];
reg        carry [3:0];
reg        i_en_reg;
reg        o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        result_reg <= 65'd0;
        i_en_reg <= 1'b0;
        o_en_reg <= 1'b0;
        sum[0] <= 64'd0;
        sum[1] <= 64'd0;
        sum[2] <= 64'd0;
        sum[3] <= 64'd0;
        carry[0] <= 1'b0;
        carry[1] <= 1'b0;
        carry[2] <= 1'b0;
        carry[3] <= 1'b0;
    end else begin
        // Stage 1: Input registers
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
            i_en_reg <= i_en;
        end else begin
            adda_reg <= adda_reg;
            addb_reg <= addb_reg;
            i_en_reg <= i_en_reg;
        end

        // Stage 2-5: Ripple carry adder
        sum[0] <= adda_reg[15:0] + addb_reg[15:0];
        carry[0] <= (adda_reg[15:0] + addb_reg[15:0]) > 16'd65535;
        sum[1] <= {adda_reg[31:16], 16'd0} + {addb_reg[31:16], 16'd0} + {16'd0, carry[0]};
        carry[1] <= ({adda_reg[31:16], 16'd0} + {addb_reg[31:16], 16'd0} + {16'd0, carry[0]}) > 32'd4294967295;
        sum[2] <= {adda_reg[47:32], 16'd0} + {addb_reg[47:32], 16'd0} + {16'd0, carry[1]};
        carry[2] <= ({adda_reg[47:32], 16'd0} + {addb_reg[47:32], 16'd0} + {16'd0, carry[1]}) > 32'd4294967295;
        sum[3] <= {adda_reg[63:48], 16'd0} + {addb_reg[63:48], 16'd0} + {16'd0, carry[2]};
        carry[3] <= ({adda_reg[63:48], 16'd0} + {addb_reg[63:48], 16'd0} + {16'd0, carry[2]}) > 32'd4294967295;

        // Stage 6: Output register
        result_reg <= {carry[3], sum[3][31:16], sum[3][15:0] + carry[2], sum[2][31:16], sum[2][15:0] + carry[1], sum[1][31:16], sum[1][15:0] + carry[0], sum[0]};
        o_en_reg <= i_en_reg;
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule