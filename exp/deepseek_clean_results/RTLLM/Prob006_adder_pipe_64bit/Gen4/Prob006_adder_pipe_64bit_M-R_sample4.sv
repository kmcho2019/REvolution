module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

parameter STAGES = 4;
parameter BITS_PER_STAGE = 16;

// Pipeline registers
reg [63:0] a_pipe [0:STAGES-1];
reg [63:0] b_pipe [0:STAGES-1];
reg [STAGES:0] carry_pipe;
reg [STAGES-1:0] en_pipe;

// Intermediate sums
wire [BITS_PER_STAGE:0] stage_sum [0:STAGES-1];

// Generate pipeline stages
genvar i;
generate
    for (i = 0; i < STAGES; i = i + 1) begin : pipeline
        // Calculate stage sum (including carry)
        assign stage_sum[i] = {1'b0, a_pipe[i][i*BITS_PER_STAGE +: BITS_PER_STAGE]} + 
                             {1'b0, b_pipe[i][i*BITS_PER_STAGE +: BITS_PER_STAGE]} + 
                             carry_pipe[i];
        
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                a_pipe[i] <= 64'b0;
                b_pipe[i] <= 64'b0;
                carry_pipe[i+1] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end else begin
                // First stage gets direct inputs
                if (i == 0) begin
                    a_pipe[0] <= adda;
                    b_pipe[0] <= addb;
                    en_pipe[0] <= i_en;
                end else begin
                    a_pipe[i] <= a_pipe[i-1];
                    b_pipe[i] <= b_pipe[i-1];
                    en_pipe[i] <= en_pipe[i-1];
                end
                
                // Propagate carry
                carry_pipe[i+1] <= stage_sum[i][BITS_PER_STAGE];
            end
        end
    end
endgenerate

// Final output stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Combine all stage sums (excluding their carries)
        result <= {carry_pipe[STAGES], 
                  stage_sum[3][BITS_PER_STAGE-1:0],
                  stage_sum[2][BITS_PER_STAGE-1:0],
                  stage_sum[1][BITS_PER_STAGE-1:0],
                  stage_sum[0][BITS_PER_STAGE-1:0]};
        o_en <= en_pipe[STAGES-1];
    end
end

endmodule