module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Segment width (4 bits)
localparam SEG_WIDTH = 4;

// Number of segments (16)
localparam NUM_SEGS = 64 / SEG_WIDTH;

// Generate segment signals
reg [SEG_WIDTH-1:0] seg_adda [NUM_SEGS-1:0];
reg [SEG_WIDTH-1:0] seg_addb [NUM_SEGS-1:0];
reg [SEG_WIDTH:0]   seg_result [NUM_SEGS-1:0];

// Pre-carry generation signals
reg [NUM_SEGS-1:0] pre_carry;

// Control unit signals
reg [3:0] stage_cnt;
reg       result_avail;

// Segment addition
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < NUM_SEGS; i++) begin
            seg_adda[i] <= 4'd0;
            seg_addb[i] <= 4'd0;
            seg_result[i] <= 5'd0;
        end
        pre_carry <= 0;
        stage_cnt <= 0;
        result_avail <= 0;
    end else if (i_en) begin
        // Segmentize input operands
        for (int i = 0; i < NUM_SEGS; i++) begin
            seg_adda[i] <= adda[(i*SEG_WIDTH)+:SEG_WIDTH];
            seg_addb[i] <= addb[(i*SEG_WIDTH)+:SEG_WIDTH];
        end
        // Pre-carry generation
        pre_carry <= 0;
        for (int i = 0; i < NUM_SEGS; i++) begin
            if (seg_adda[i] + seg_addb[i] >= 16) begin
                pre_carry[i] <= 1;
            end
        end
    end else if (stage_cnt < NUM_SEGS) begin
        // Perform segment addition
        for (int i = 0; i < NUM_SEGS; i++) begin
            if (i == stage_cnt) begin
                seg_result[i] <= {1'b0, seg_adda[i]} + {1'b0, seg_addb[i]} + pre_carry[i];
            end
        end
        stage_cnt <= stage_cnt + 1;
    end else if (stage_cnt == NUM_SEGS) begin
        // Final result calculation
        result <= {1'b0, seg_result[NUM_SEGS-1]} + {1'b0, seg_result[NUM_SEGS-2]};
        result_avail <= 1;
    end
end

// Control unit
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en <= 0;
    end else if (result_avail) begin
        o_en <= 1;
    end else begin
        o_en <= 0;
    end
end

endmodule