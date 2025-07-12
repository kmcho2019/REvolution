module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline parameters
localparam STAGE_WIDTH = 16;
localparam NUM_STAGES = 4;
localparam PIPELINE_DEPTH = NUM_STAGES;

// Pipeline registers
reg [63:0] a_pipe [0:NUM_STAGES-1];
reg [63:0] b_pipe [0:NUM_STAGES-1];
reg [NUM_STAGES:0] carry_pipe;
reg [PIPELINE_DEPTH:0] en_pipe;

// Stage outputs
wire [STAGE_WIDTH:0] stage_sum [0:NUM_STAGES-1];

// Generate all stages
genvar i;
generate
    for (i = 0; i < NUM_STAGES; i = i + 1) begin : STAGES
        // Current stage inputs
        wire [STAGE_WIDTH-1:0] a_stage = a_pipe[i][i*STAGE_WIDTH +: STAGE_WIDTH];
        wire [STAGE_WIDTH-1:0] b_stage = b_pipe[i][i*STAGE_WIDTH +: STAGE_WIDTH];
        
        // Compute stage sum with carry in
        assign stage_sum[i] = {1'b0, a_stage} + {1'b0, b_stage} + carry_pipe[i];
    end
endgenerate

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear pipeline registers
        for (int j = 0; j < NUM_STAGES; j = j + 1) begin
            a_pipe[j] <= 64'b0;
            b_pipe[j] <= 64'b0;
        end
        carry_pipe <= '0;
        en_pipe <= '0;
        result <= '0;
        o_en <= 1'b0;
    end else begin
        // Shift enable through pipeline
        en_pipe <= {en_pipe[PIPELINE_DEPTH-1:0], i_en};
        
        // First pipeline stage - register inputs
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        carry_pipe[0] <= 1'b0;  // Initial carry in
        
        // Intermediate pipeline stages
        for (int j = 1; j < NUM_STAGES; j = j + 1) begin
            a_pipe[j] <= a_pipe[j-1];
            b_pipe[j] <= b_pipe[j-1];
            carry_pipe[j] <= stage_sum[j-1][STAGE_WIDTH];  // Carry out becomes next carry in
        end
        
        // Final pipeline stage - assemble result
        if (en_pipe[PIPELINE_DEPTH]) begin
            // Combine all stage results
            result[64] <= carry_pipe[NUM_STAGES];  // Final carry out
            
            // First stage
            result[0 +: STAGE_WIDTH] <= stage_sum[0][STAGE_WIDTH-1:0];
            
            // Middle stages
            for (int j = 1; j < NUM_STAGES; j = j + 1) begin
                result[j*STAGE_WIDTH +: STAGE_WIDTH] <= stage_sum[j][STAGE_WIDTH-1:0];
            end
            
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule