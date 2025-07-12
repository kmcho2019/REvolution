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
reg [STAGES:0] enable_pipe;
reg [64:0] sum_pipe [0:STAGES-1];

// Intermediate carries
wire [STAGES:0] carry;
assign carry[0] = 1'b0;

// Generate pipeline stages
genvar i;
generate
    for (i = 0; i < STAGES; i = i + 1) begin : stage
        // Current slice of operands
        wire [BITS_PER_STAGE-1:0] a_slice = (i == 0) ? adda[i*BITS_PER_STAGE +: BITS_PER_STAGE] : 
                                             adda_pipe[i-1][i*BITS_PER_STAGE +: BITS_PER_STAGE];
        wire [BITS_PER_STAGE-1:0] b_slice = (i == 0) ? addb[i*BITS_PER_STAGE +: BITS_PER_STAGE] : 
                                             addb_pipe[i-1][i*BITS_PER_STAGE +: BITS_PER_STAGE];
        
        // Current stage addition
        wire [BITS_PER_STAGE:0] stage_sum = {1'b0, a_slice} + {1'b0, b_slice} + carry[i];
        
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                adda_pipe[i] <= 64'b0;
                addb_pipe[i] <= 64'b0;
                sum_pipe[i] <= 65'b0;
                enable_pipe[i+1] <= 1'b0;
                carry[i+1] <= 1'b0;
            end else begin
                // Register operands (full width to preserve bits for next stages)
                if (i == 0) begin
                    adda_pipe[i] <= adda;
                    addb_pipe[i] <= addb;
                end else begin
                    adda_pipe[i] <= adda_pipe[i-1];
                    addb_pipe[i] <= addb_pipe[i-1];
                end
                
                // Register sum and carry
                if (i < STAGES-1) begin
                    sum_pipe[i][i*BITS_PER_STAGE +: BITS_PER_STAGE] <= stage_sum[BITS_PER_STAGE-1:0];
                end else begin
                    // Final stage captures all bits
                    sum_pipe[i] <= {stage_sum[BITS_PER_STAGE], sum_pipe[i-1][63:BITS_PER_STAGE*(STAGES-1)], 
                                  stage_sum[BITS_PER_STAGE-1:0]};
                end
                
                carry[i+1] <= stage_sum[BITS_PER_STAGE];
                enable_pipe[i+1] <= enable_pipe[i];
            end
        end
    end
endgenerate

// Input stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        enable_pipe[0] <= 1'b0;
    end else begin
        enable_pipe[0] <= i_en;
    end
end

// Output stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= sum_pipe[STAGES-1];
        o_en <= enable_pipe[STAGES];
    end
end

endmodule