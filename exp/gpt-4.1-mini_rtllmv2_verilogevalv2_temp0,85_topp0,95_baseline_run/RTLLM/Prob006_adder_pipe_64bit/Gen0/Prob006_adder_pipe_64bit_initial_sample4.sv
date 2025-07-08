module adder_pipe_64bit (
    input          clk,
    input          rst_n,
    input          i_en,
    input  [63:0]  adda,
    input  [63:0]  addb,
    output reg [64:0] result,
    output reg     o_en
);

// Pipeline parameters
localparam STAGE_WIDTH = 16;
localparam NUM_STAGES = 4;

// Pipeline registers for operands and enable
reg [63:0] adda_r [0:NUM_STAGES];
reg [63:0] addb_r [0:NUM_STAGES];
reg        en_r   [0:NUM_STAGES];

// Pipeline registers for partial sums and carries
reg [STAGE_WIDTH-1:0] sum_stage [0:NUM_STAGES-1];
reg carry_stage [0:NUM_STAGES];

// Stage 0: register inputs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_r[0] <= 64'd0;
        addb_r[0] <= 64'd0;
        en_r[0] <= 1'b0;
    end else begin
        if (i_en) begin
            adda_r[0] <= adda;
            addb_r[0] <= addb;
        end
        en_r[0] <= i_en;
    end
end

// Stage 1 to NUM_STAGES: register inputs and enables from previous stage
genvar i;
generate
    for (i=1; i<=NUM_STAGES; i=i+1) begin : PIPE_REGS
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                adda_r[i] <= 64'd0;
                addb_r[i] <= 64'd0;
                en_r[i] <= 1'b0;
            end else begin
                adda_r[i] <= adda_r[i-1];
                addb_r[i] <= addb_r[i-1];
                en_r[i] <= en_r[i-1];
            end
        end
    end
endgenerate

// Ripple carry add pipeline stages
// Stage 0 addition: bits [15:0]
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage[0] <= 0;
        carry_stage[0] <= 0;
    end else if (en_r[0]) begin
        {carry_stage[0], sum_stage[0]} <= adda_r[0][15:0] + addb_r[0][15:0];
    end else begin
        sum_stage[0] <= 0;
        carry_stage[0] <= 0;
    end
end

// Stage 1 addition: bits [31:16] + carry from stage 0
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage[1] <= 0;
        carry_stage[1] <= 0;
    end else if (en_r[1]) begin
        {carry_stage[1], sum_stage[1]} <= adda_r[1][31:16] + addb_r[1][31:16] + carry_stage[0];
    end else begin
        sum_stage[1] <= 0;
        carry_stage[1] <= 0;
    end
end

// Stage 2 addition: bits [47:32] + carry from stage 1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage[2] <= 0;
        carry_stage[2] <= 0;
    end else if (en_r[2]) begin
        {carry_stage[2], sum_stage[2]} <= adda_r[2][47:32] + addb_r[2][47:32] + carry_stage[1];
    end else begin
        sum_stage[2] <= 0;
        carry_stage[2] <= 0;
    end
end

// Stage 3 addition: bits [63:48] + carry from stage 2
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage[3] <= 0;
        carry_stage[3] <= 0;
    end else if (en_r[3]) begin
        {carry_stage[3], sum_stage[3]} <= adda_r[3][63:48] + addb_r[3][63:48] + carry_stage[2];
    end else begin
        sum_stage[3] <= 0;
        carry_stage[3] <= 0;
    end
end

// Final output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
    end else begin
        if (en_r[NUM_STAGES]) begin
            result <= {carry_stage[3], sum_stage[3], sum_stage[2], sum_stage[1], sum_stage[0]};
            o_en <= 1'b1;
        end else begin
            result <= 65'd0;
            o_en <= 1'b0;
        end
    end
end

endmodule