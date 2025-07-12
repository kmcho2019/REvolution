module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [16:0] seg_result [3:0];
reg [64:0] out_result;
reg o_en_reg;
reg [1:0] pipeline_counter;

assign result = out_result;
assign o_en = o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out_result <= 65'd0;
        o_en_reg <= 1'b0;
        for (int i = 0; i < 4; i++) begin
            seg_result[i] <= 17'd0;
        end
        pipeline_counter <= 2'd0;
    end else begin
        if (i_en) begin
            // Reset pipeline counter when a new operation is requested
            pipeline_counter <= 2'd1;
        end

        case (pipeline_counter)
            2'd1: begin
                // Segment 0
                seg_result[0] <= {1'b0, adda[15:0]} + {1'b0, addb[15:0]};
                // Segments 1 to 3 with carry propagation
                for (int i = 1; i < 4; i++) begin
                    seg_result[i] <= {1'b0, adda[(i*16)+15:(i*16)]} + {1'b0, addb[(i*16)+15:(i*16)]} + {16'b0, seg_result[i-1][16]};
                end
                pipeline_counter <= 2'd2;
            end
            2'd2: begin
                out_result <= {seg_result[3][16], seg_result[3][15:0], seg_result[2][15:0], seg_result[1][15:0], seg_result[0][15:0]};
                o_en_reg <= 1'b1;
                pipeline_counter <= 2'd3;
            end
            2'd3: begin
                o_en_reg <= 1'b0;
                pipeline_counter <= 2'd0;
            end
            default: begin
                // Do nothing, pipeline is idle
            end
        endcase
    end
end

endmodule