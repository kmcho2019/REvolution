module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Constants
localparam BLOCK_WIDTH = 16;
localparam NUM_BLOCKS = 4;
localparam PIPELINE_DEPTH = NUM_BLOCKS;

// Pipeline registers
reg [63:0] a_pipe [0:PIPELINE_DEPTH-1];
reg [63:0] b_pipe [0:PIPELINE_DEPTH-1];
reg [NUM_BLOCKS:0] carry_pipe;
reg [PIPELINE_DEPTH:0] en_pipe;

// Block sum outputs (carry=0 and carry=1 versions)
wire [BLOCK_WIDTH:0] sum0 [0:NUM_BLOCKS-1];
wire [BLOCK_WIDTH:0] sum1 [0:NUM_BLOCKS-1];

// Selected sums for each block
wire [BLOCK_WIDTH-1:0] selected_sum [0:NUM_BLOCKS-1];

// Generate all block sums
always @(*) begin
    for (int i = 0; i < NUM_BLOCKS; i = i + 1) begin
        // Compute both possible sums for each block
        sum0[i] = {1'b0, a_pipe[i][i*BLOCK_WIDTH +: BLOCK_WIDTH]} + 
                 {1'b0, b_pipe[i][i*BLOCK_WIDTH +: BLOCK_WIDTH]};
        sum1[i] = sum0[i] + 1'b1;
        
        // Select correct sum based on carry
        selected_sum[i] = carry_pipe[i] ? sum1[i][BLOCK_WIDTH-1:0] : 
                                        sum0[i][BLOCK_WIDTH-1:0];
    end
end

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear pipeline registers
        for (int i = 0; i < PIPELINE_DEPTH; i = i + 1) begin
            a_pipe[i] <= 64'b0;
            b_pipe[i] <= 64'b0;
        end
        carry_pipe <= '0;
        en_pipe <= '0;
        result <= '0;
        o_en <= 1'b0;
    end else begin
        // Shift enable signal through pipeline
        en_pipe <= {en_pipe[PIPELINE_DEPTH-1:0], i_en};
        
        // First pipeline stage - register inputs
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        carry_pipe[0] <= 1'b0;  // Initial carry-in
        
        // Intermediate pipeline stages
        for (int i = 1; i < PIPELINE_DEPTH; i = i + 1) begin
            a_pipe[i] <= a_pipe[i-1];
            b_pipe[i] <= b_pipe[i-1];
            carry_pipe[i] <= carry_pipe[i-1] ? sum1[i-1][BLOCK_WIDTH] : 
                                             sum0[i-1][BLOCK_WIDTH];
        end
        
        // Output stage
        if (en_pipe[PIPELINE_DEPTH]) begin
            // Assemble final result
            result[64] <= carry_pipe[NUM_BLOCKS];  // Final carry out
            
            // First block
            result[0 +: BLOCK_WIDTH] <= selected_sum[0];
            
            // Middle blocks
            for (int i = 1; i < NUM_BLOCKS; i = i + 1) begin
                result[i*BLOCK_WIDTH +: BLOCK_WIDTH] <= selected_sum[i];
            end
            
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule