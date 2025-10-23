module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage parameters
localparam STAGES = 4;
localparam BITS_PER_STAGE = 16;

// Pipeline registers
reg [63:0] adda_pipe [0:STAGES-1];
reg [63:0] addb_pipe [0:STAGES-1];
reg [STAGES-1:0] en_pipe;
reg [BITS_PER_STAGE:0] stage_sum [0:STAGES-1]; // [16:0] - sum + carry out
reg [STAGES:0] carry_chain; // Carry between stages

// Generate pipeline stages
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer i = 0; i < STAGES; i = i + 1) begin
            adda_pipe[i] <= 64'b0;
            addb_pipe[i] <= 64'b0;
            stage_sum[i] <= {(BITS_PER_STAGE+1){1'b0}};
        end
        en_pipe <= {STAGES{1'b0}};
        carry_chain <= {(STAGES+1){1'b0}};
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 0: Input registers and first addition
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        en_pipe[0] <= i_en;
        stage_sum[0] <= {1'b0, adda[BITS_PER_STAGE-1:0]} + 
                       {1'b0, addb[BITS_PER_STAGE-1:0]};
        carry_chain[0] <= 1'b0;

        // Pipeline stages 1-3
        for (integer i = 1; i < STAGES; i = i + 1) begin
            adda_pipe[i] <= adda_pipe[i-1];
            addb_pipe[i] <= addb_pipe[i-1];
            en_pipe[i] <= en_pipe[i-1];
            
            // Compute partial sum with carry in
            stage_sum[i] <= {1'b0, adda_pipe[i-1][i*BITS_PER_STAGE +: BITS_PER_STAGE]} + 
                           {1'b0, addb_pipe[i-1][i*BITS_PER_STAGE +: BITS_PER_STAGE]} + 
                           carry_chain[i];
            
            // Carry out becomes carry in for next stage
            carry_chain[i+1] <= stage_sum[i][BITS_PER_STAGE];
        end

        // Final output assembly
        if (en_pipe[STAGES-1]) begin
            result <= {carry_chain[STAGES], 
                      stage_sum[3][BITS_PER_STAGE-1:0],
                      stage_sum[2][BITS_PER_STAGE-1:0],
                      stage_sum[1][BITS_PER_STAGE-1:0],
                      stage_sum[0][BITS_PER_STAGE-1:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule