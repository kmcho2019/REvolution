module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Parameters for pipeline configuration
parameter STAGES = 4;
parameter BITS_PER_STAGE = 16;

// Pipeline registers
reg [BITS_PER_STAGE-1:0] adda_pipe [0:STAGES-1];
reg [BITS_PER_STAGE-1:0] addb_pipe [0:STAGES-1];
reg [STAGES-1:0] carry_pipe;
reg [BITS_PER_STAGE-1:0] sum_pipe [0:STAGES-1];
reg [STAGES-1:0] en_pipe;

// Intermediate signals
wire [BITS_PER_STAGE:0] stage_sum [0:STAGES-1]; // {carry, sum}

// Generate adder stages
genvar i;
generate
    for (i = 0; i < STAGES; i = i + 1) begin : adder_stages
        if (i == 0) begin
            // First stage - no carry in
            assign stage_sum[i] = {1'b0, adda[BITS_PER_STAGE-1:0]} + 
                                 {1'b0, addb[BITS_PER_STAGE-1:0]};
        end else begin
            // Subsequent stages - carry from previous stage
            assign stage_sum[i] = {1'b0, adda_pipe[i-1]} + 
                                 {1'b0, addb_pipe[i-1]} + 
                                 carry_pipe[i-1];
        end
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        for (integer j = 0; j < STAGES; j = j + 1) begin
            adda_pipe[j] <= {BITS_PER_STAGE{1'b0}};
            addb_pipe[j] <= {BITS_PER_STAGE{1'b0}};
            sum_pipe[j] <= {BITS_PER_STAGE{1'b0}};
        end
        carry_pipe <= {STAGES{1'b0}};
        en_pipe <= {STAGES{1'b0}};
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 0 - input registers
        adda_pipe[0] <= adda[BITS_PER_STAGE-1:0];
        addb_pipe[0] <= addb[BITS_PER_STAGE-1:0];
        en_pipe[0] <= i_en;
        carry_pipe[0] <= stage_sum[0][BITS_PER_STAGE];
        sum_pipe[0] <= stage_sum[0][BITS_PER_STAGE-1:0];

        // Pipeline stages 1 to 3
        for (integer j = 1; j < STAGES; j = j + 1) begin
            adda_pipe[j] <= adda[(j+1)*BITS_PER_STAGE-1:j*BITS_PER_STAGE];
            addb_pipe[j] <= addb[(j+1)*BITS_PER_STAGE-1:j*BITS_PER_STAGE];
            en_pipe[j] <= en_pipe[j-1];
            carry_pipe[j] <= stage_sum[j][BITS_PER_STAGE];
            sum_pipe[j] <= stage_sum[j][BITS_PER_STAGE-1:0];
        end

        // Final result assembly
        result <= {carry_pipe[STAGES-1], 
                 sum_pipe[3], sum_pipe[2], 
                 sum_pipe[1], sum_pipe[0]};

        // Output enable is the last enable in pipeline
        o_en <= en_pipe[STAGES-1];
    end
end

endmodule