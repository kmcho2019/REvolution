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
localparam PIPELINE_DEPTH = 4;
localparam BLOCK_SIZE = 4;
localparam NUM_BLOCKS = 16;

// Pipeline registers
reg [63:0] a_pipe [0:PIPELINE_DEPTH-1];
reg [63:0] b_pipe [0:PIPELINE_DEPTH-1];
reg [0:PIPELINE_DEPTH-1] en_pipe;

// Generate/Propagate terms
wire [NUM_BLOCKS-1:0] P0, G0;
reg [NUM_BLOCKS-1:0] P1, G1;
wire [3:0] P1_level2, G1_level2;
reg [3:0] P2, G2;
wire P3, G3;

// Carry signals
wire [NUM_BLOCKS:0] carry;
reg [NUM_BLOCKS:0] carry_reg;

// Stage 1: Compute 4-bit block generate/propagate terms
genvar i;
generate
    for (i = 0; i < NUM_BLOCKS; i = i + 1) begin : BLOCK_GEN
        assign P0[i] = &(adda[i*BLOCK_SIZE +: BLOCK_SIZE] ^ addb[i*BLOCK_SIZE +: BLOCK_SIZE]);
        assign G0[i] = |(adda[i*BLOCK_SIZE +: BLOCK_SIZE] & addb[i*BLOCK_SIZE +: BLOCK_SIZE]);
    end
endgenerate

// Stage 2: Compute 16-bit group generate/propagate terms (4 blocks each)
generate
    for (i = 0; i < 4; i = i + 1) begin : GROUP_GEN
        assign P1_level2[i] = &P1[i*4 +: 4];
        assign G1_level2[i] = |(G1[i*4 +: 4] & {4{P1[i*4 +: 4]}});
    end
endgenerate

// Stage 3: Compute final carry terms
assign P3 = &P2;
assign G3 = |(G2 & {4{P2}});
assign carry[0] = 1'b0;

generate
    for (i = 0; i < NUM_BLOCKS; i = i + 1) begin : CARRY_GEN
        assign carry[i+1] = G1[i] | (P1[i] & carry[i]);
    end
endgenerate

// Pipeline control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset pipeline registers
        for (integer j = 0; j < PIPELINE_DEPTH; j = j + 1) begin
            a_pipe[j] <= 64'b0;
            b_pipe[j] <= 64'b0;
            en_pipe[j] <= 1'b0;
        end
        
        P1 <= {NUM_BLOCKS{1'b0}};
        G1 <= {NUM_BLOCKS{1'b0}};
        P2 <= 4'b0;
        G2 <= 4'b0;
        carry_reg <= {(NUM_BLOCKS+1){1'b0}};
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 1
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        P1 <= P0;
        G1 <= G0;
        en_pipe[0] <= i_en;
        
        // Pipeline stage 2
        a_pipe[1] <= a_pipe[0];
        b_pipe[1] <= b_pipe[0];
        P2 <= P1_level2;
        G2 <= G1_level2;
        en_pipe[1] <= en_pipe[0];
        
        // Pipeline stage 3
        a_pipe[2] <= a_pipe[1];
        b_pipe[2] <= b_pipe[1];
        carry_reg <= carry;
        en_pipe[2] <= en_pipe[1];
        
        // Pipeline stage 4
        a_pipe[3] <= a_pipe[2];
        b_pipe[3] <= b_pipe[2];
        en_pipe[3] <= en_pipe[2];
        
        // Final output
        if (en_pipe[3]) begin
            // Combine sums with final carries
            for (integer j = 0; j < NUM_BLOCKS; j = j + 1) begin
                result[j*BLOCK_SIZE +: BLOCK_SIZE] <= 
                    a_pipe[3][j*BLOCK_SIZE +: BLOCK_SIZE] ^ 
                    b_pipe[3][j*BLOCK_SIZE +: BLOCK_SIZE] ^ 
                    {BLOCK_SIZE{carry_reg[j]}};
            end
            result[64] <= carry_reg[NUM_BLOCKS];
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule