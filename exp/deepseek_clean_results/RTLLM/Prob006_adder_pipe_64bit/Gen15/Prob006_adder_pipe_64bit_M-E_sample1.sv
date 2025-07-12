module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Block parameters
localparam BLOCK_WIDTH = 16;
localparam NUM_BLOCKS = 4;
localparam PIPELINE_STAGES = NUM_BLOCKS + 1;

// Pipeline registers
reg [63:0] a_pipe [0:NUM_BLOCKS-1];
reg [63:0] b_pipe [0:NUM_BLOCKS-1];
reg [NUM_BLOCKS:0] carry_pipe;
reg [PIPELINE_STAGES-1:0] en_shift_reg = 0;

// Block outputs (0 and 1 versions for carry-select)
wire [BLOCK_WIDTH:0] block_sum0 [0:NUM_BLOCKS-1]; // sum with carry=0
wire [BLOCK_WIDTH:0] block_sum1 [0:NUM_BLOCKS-1]; // sum with carry=1
reg [BLOCK_WIDTH:0] block_sum_reg [0:NUM_BLOCKS-1]; // registered sum

// Generate all blocks
genvar i;
generate
    for (i = 0; i < NUM_BLOCKS; i = i + 1) begin : BLOCKS
        // Current block inputs
        wire [BLOCK_WIDTH-1:0] a_block = a_pipe[i][i*BLOCK_WIDTH +: BLOCK_WIDTH];
        wire [BLOCK_WIDTH-1:0] b_block = b_pipe[i][i*BLOCK_WIDTH +: BLOCK_WIDTH];
        
        // Compute both possible sums
        assign block_sum0[i] = {1'b0, a_block} + {1'b0, b_block};
        assign block_sum1[i] = {1'b0, a_block} + {1'b0, b_block} + 1'b1;
    end
endgenerate

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int j = 0; j < NUM_BLOCKS; j = j + 1) begin
            a_pipe[j] <= 64'b0;
            b_pipe[j] <= 64'b0;
            block_sum_reg[j] <= '0;
        end
        carry_pipe <= '0;
        en_shift_reg <= '0;
        result <= '0;
        o_en <= 1'b0;
    end else begin
        // Shift enable through pipeline
        en_shift_reg <= {en_shift_reg[PIPELINE_STAGES-2:0], i_en};
        
        // First pipeline stage - register inputs
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        carry_pipe[0] <= 1'b0;  // Initial carry in
        
        // Intermediate pipeline stages
        for (int j = 1; j < NUM_BLOCKS; j = j + 1) begin
            a_pipe[j] <= a_pipe[j-1];
            b_pipe[j] <= b_pipe[j-1];
            
            // Select correct sum based on previous carry
            block_sum_reg[j] <= carry_pipe[j-1] ? block_sum1[j-1] : block_sum0[j-1];
            carry_pipe[j] <= carry_pipe[j-1] ? block_sum1[j-1][BLOCK_WIDTH] : 
                                             block_sum0[j-1][BLOCK_WIDTH];
        end
        
        // Final pipeline stage - assemble result
        if (en_shift_reg[PIPELINE_STAGES-1]) begin
            // Combine all block results
            result[64] <= carry_pipe[NUM_BLOCKS-1];  // Final carry out
            
            // First block
            result[0 +: BLOCK_WIDTH] <= carry_pipe[0] ? block_sum1[0][BLOCK_WIDTH-1:0] : 
                                                      block_sum0[0][BLOCK_WIDTH-1:0];
            
            // Middle blocks
            for (int j = 1; j < NUM_BLOCKS; j = j + 1) begin
                result[j*BLOCK_WIDTH +: BLOCK_WIDTH] <= block_sum_reg[j][BLOCK_WIDTH-1:0];
            end
            
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule