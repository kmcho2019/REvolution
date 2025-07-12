module adder_pipe_64bit #(
    parameter BLOCK_WIDTH = 32,    // Configurable block width
    parameter PIPELINE_DEPTH = 2   // Configurable pipeline stages
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

localparam NUM_BLOCKS = 64 / BLOCK_WIDTH;

// Pipeline registers
reg [63:0] a_pipe [0:PIPELINE_DEPTH-1];
reg [63:0] b_pipe [0:PIPELINE_DEPTH-1];
reg [NUM_BLOCKS:0] carry_pipe;
reg [PIPELINE_DEPTH:0] en_pipe;

// Block sum and carry computation
wire [BLOCK_WIDTH:0] block_sum [0:NUM_BLOCKS-1];
wire [NUM_BLOCKS:0] carry_lookahead;

// Generate block sums and carry lookahead
always @(*) begin
    for (int i = 0; i < NUM_BLOCKS; i = i + 1) begin
        block_sum[i] = {1'b0, a_pipe[0][i*BLOCK_WIDTH +: BLOCK_WIDTH]} + 
                       {1'b0, b_pipe[0][i*BLOCK_WIDTH +: BLOCK_WIDTH]} + 
                       carry_lookahead[i];
    end
end

// Carry lookahead logic
assign carry_lookahead[0] = 1'b0;
always @(*) begin
    for (int i = 1; i <= NUM_BLOCKS; i = i + 1) begin
        carry_lookahead[i] = block_sum[i-1][BLOCK_WIDTH];
    end
end

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear pipeline registers
        for (int i = 0; i < PIPELINE_DEPTH; i = i + 1) begin
            a_pipe[i] <= '0;
            b_pipe[i] <= '0;
        end
        carry_pipe <= '0;
        en_pipe <= '0;
        result <= '0;
        o_en <= 1'b0;
    end else begin
        // Shift enable and data through pipeline
        en_pipe <= {en_pipe[PIPELINE_DEPTH-1:0], i_en};
        
        // First stage registers
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        
        // Second stage registers
        if (PIPELINE_DEPTH > 1) begin
            a_pipe[1] <= a_pipe[0];
            b_pipe[1] <= b_pipe[0];
            carry_pipe <= carry_lookahead;
        end else begin
            carry_pipe <= carry_lookahead;
        end
        
        // Output stage
        if (en_pipe[PIPELINE_DEPTH]) begin
            // Assemble final result
            result[64] <= carry_pipe[NUM_BLOCKS];  // Final carry
            
            // Combine block sums
            for (int i = 0; i < NUM_BLOCKS; i = i + 1) begin
                result[i*BLOCK_WIDTH +: BLOCK_WIDTH] <= 
                    block_sum[i][BLOCK_WIDTH-1:0];
            end
            
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule