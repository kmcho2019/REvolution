module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

parameter DATA_WIDTH = 64;
parameter STG_WIDTH = 16;
parameter NUM_STAGES = DATA_WIDTH / STG_WIDTH;

reg [STG_WIDTH-1:0] seg_adda [NUM_STAGES-1:0];
reg [STG_WIDTH-1:0] seg_addb [NUM_STAGES-1:0];
reg [STG_WIDTH:0] seg_result [NUM_STAGES-1:0];
reg [DATA_WIDTH+1:0] out_result;
reg o_en_reg;

assign result = out_result;
assign o_en = o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out_result <= {DATA_WIDTH+1{1'b0}};
        o_en_reg <= 1'b0;
        for (int i = 0; i < NUM_STAGES; i++) begin
            seg_adda[i] <= {STG_WIDTH{1'b0}};
            seg_addb[i] <= {STG_WIDTH{1'b0}};
            seg_result[i] <= {STG_WIDTH+1{1'b0}};
        end
    end else begin
        if (i_en) begin
            for (int i = 0; i < NUM_STAGES; i++) begin
                seg_adda[i] <= adda[(i+1)*STG_WIDTH-1:i*STG_WIDTH];
                seg_addb[i] <= addb[(i+1)*STG_WIDTH-1:i*STG_WIDTH];
            end
        end

        seg_result[0] <= {1'b0, seg_adda[0]} + {1'b0, seg_addb[0]};
        for (int i = 1; i < NUM_STAGES; i++) begin
            seg_result[i] <= {1'b0, seg_adda[i]} + {1'b0, seg_addb[i]} + {STG_WIDTH{1'b0}, seg_result[i-1][STG_WIDTH]};
        end

        out_result <= {seg_result[NUM_STAGES-1][STG_WIDTH], {NUM_STAGES{1'b0}}};
        for (int i = NUM_STAGES-1; i >= 0; i--) begin
            out_result[(NUM_STAGES-i-1)*STG_WIDTH+STG_WIDTH-1 : (NUM_STAGES-i-1)*STG_WIDTH] <= seg_result[i][STG_WIDTH-1:0];
        end
        o_en_reg <= i_en;
    end
end

endmodule