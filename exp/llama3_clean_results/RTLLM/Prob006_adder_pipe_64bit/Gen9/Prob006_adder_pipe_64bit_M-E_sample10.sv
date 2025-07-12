module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

// Define the number of blocks and bits per block
parameter BLOCKS = 16;
parameter BITS_PER_BLOCK = 4;

// Define the input and output registers
reg [BITS_PER_BLOCK-1:0] block_adda [BLOCKS-1:0];
reg [BITS_PER_BLOCK-1:0] block_addb [BLOCKS-1:0];
reg [BITS_PER_BLOCK-1:0] block_sum [BLOCKS-1:0];
reg [BITS_PER_BLOCK:0] block_carry [BLOCKS-1:0];

// Define the output register
reg [64:0] result_reg;

// Define the output enable signal register
reg o_en_reg;

// Initialize the blocks and carry signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < BLOCKS; i++) begin
            block_adda[i] <= {BITS_PER_BLOCK{1'b0}};
            block_addb[i] <= {BITS_PER_BLOCK{1'b0}};
            block_sum[i] <= {BITS_PER_BLOCK{1'b0}};
            block_carry[i] <= {BITS_PER_BLOCK+1{1'b0}};
        end
        result_reg <= {65{1'b0}};
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        // Divide the input operands into blocks
        for (int i = 0; i < BLOCKS; i++) begin
            block_adda[i] <= adda[(i*BITS_PER_BLOCK)+:BITS_PER_BLOCK];
            block_addb[i] <= addb[(i*BITS_PER_BLOCK)+:BITS_PER_BLOCK];
        end

        // Perform the addition and generate carry signals
        for (int i = 0; i < BLOCKS; i++) begin
            {block_sum[i], block_carry[i]} <= block_adda[i] + block_addb[i] + (i == 0 ? 1'b0 : block_carry[i-1][BITS_PER_BLOCK]);
        end

        // Generate the final output
        result_reg <= {block_carry[BLOCKS-1][BITS_PER_BLOCK], block_sum[BLOCKS-1], block_sum[BLOCKS-2], block_sum[BLOCKS-3], block_sum[BLOCKS-4], block_sum[BLOCKS-5], block_sum[BLOCKS-6], block_sum[BLOCKS-7], block_sum[BLOCKS-8], block_sum[BLOCKS-9], block_sum[BLOCKS-10], block_sum[BLOCKS-11], block_sum[BLOCKS-12], block_sum[BLOCKS-13], block_sum[BLOCKS-14], block_sum[BLOCKS-15]};

        // Generate the output enable signal
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule