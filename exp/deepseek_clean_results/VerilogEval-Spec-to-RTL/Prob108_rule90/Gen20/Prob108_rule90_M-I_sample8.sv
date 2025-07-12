module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

parameter WIDTH = 512;
parameter PIPELINE_STAGES = 4;
parameter STAGE_WIDTH = WIDTH/PIPELINE_STAGES;

reg [WIDTH-1:0] q_reg;
reg [WIDTH-1:0] next_q;
wire update_en = ~load;  // Clock gating control

// Pipeline registers
reg [STAGE_WIDTH-1:0] stage0_out;
reg [STAGE_WIDTH-1:0] stage1_out;
reg [STAGE_WIDTH-1:0] stage2_out;

// Generate next state with pipelining
integer i;
always @(*) begin
    // Stage 0: Bits 0-127
    for (i = 0; i < STAGE_WIDTH; i = i + 1) begin
        wire left = (i == 0) ? 1'b0 : q_reg[i-1];
        wire right = (i == STAGE_WIDTH-1) ? 1'b0 : q_reg[i+1];
        stage0_out[i] = left ^ right;
    end

    // Stage 1: Bits 128-255
    for (i = STAGE_WIDTH; i < 2*STAGE_WIDTH; i = i + 1) begin
        wire left = q_reg[i-1];
        wire right = (i == 2*STAGE_WIDTH-1) ? 1'b0 : q_reg[i+1];
        stage1_out[i-STAGE_WIDTH] = left ^ right;
    end

    // Stage 2: Bits 256-383
    for (i = 2*STAGE_WIDTH; i < 3*STAGE_WIDTH; i = i + 1) begin
        wire left = q_reg[i-1];
        wire right = (i == 3*STAGE_WIDTH-1) ? 1'b0 : q_reg[i+1];
        stage2_out[i-2*STAGE_WIDTH] = left ^ right;
    end

    // Stage 3: Bits 384-511
    for (i = 3*STAGE_WIDTH; i < WIDTH; i = i + 1) begin
        wire left = q_reg[i-1];
        wire right = (i == WIDTH-1) ? 1'b0 : q_reg[i+1];
        next_q[i] = left ^ right;
    end
end

// Clock gated update
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (update_en) begin
        // Pipeline the results
        next_q[STAGE_WIDTH-1:0] <= stage0_out;
        next_q[2*STAGE_WIDTH-1:STAGE_WIDTH] <= stage1_out;
        next_q[3*STAGE_WIDTH-1:2*STAGE_WIDTH] <= stage2_out;
        q_reg <= next_q;
    end
end

assign q = q_reg;

endmodule