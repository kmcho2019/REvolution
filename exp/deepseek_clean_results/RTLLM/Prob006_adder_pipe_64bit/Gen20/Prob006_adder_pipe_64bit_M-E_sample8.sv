module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Parameters for configurable design
parameter CHUNK_SIZE = 16;
parameter NUM_CHUNKS = 4;

// Pipeline stage registers
reg [63:0] a_stage1, b_stage1;
reg [63:0] a_stage2, b_stage2;
reg [63:0] a_stage3, b_stage3;
reg en_stage1, en_stage2, en_stage3;

// Chunk sum registers (with carry=0 and carry=1)
reg [CHUNK_SIZE:0] sum0_0, sum0_1, sum1_0, sum1_1, sum2_0, sum2_1, sum3_0, sum3_1;
reg carry1, carry2, carry3;

// Intermediate results
wire [CHUNK_SIZE-1:0] chunk0_a = a_stage2[15:0];
wire [CHUNK_SIZE-1:0] chunk1_a = a_stage2[31:16];
wire [CHUNK_SIZE-1:0] chunk2_a = a_stage2[47:32];
wire [CHUNK_SIZE-1:0] chunk3_a = a_stage2[63:48];

wire [CHUNK_SIZE-1:0] chunk0_b = b_stage2[15:0];
wire [CHUNK_SIZE-1:0] chunk1_b = b_stage2[31:16];
wire [CHUNK_SIZE-1:0] chunk2_b = b_stage2[47:32];
wire [CHUNK_SIZE-1:0] chunk3_b = b_stage2[63:48];

// Stage 2: Compute both possible sums for each chunk
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        a_stage1 <= 64'b0; b_stage1 <= 64'b0;
        a_stage2 <= 64'b0; b_stage2 <= 64'b0;
        a_stage3 <= 64'b0; b_stage3 <= 64'b0;
        en_stage1 <= 1'b0; en_stage2 <= 1'b0; en_stage3 <= 1'b0;
        
        sum0_0 <= 0; sum0_1 <= 0;
        sum1_0 <= 0; sum1_1 <= 0;
        sum2_0 <= 0; sum2_1 <= 0;
        sum3_0 <= 0; sum3_1 <= 0;
        carry1 <= 0; carry2 <= 0; carry3 <= 0;
    end else begin
        // Stage 1: Register inputs
        if (i_en) begin
            a_stage1 <= adda;
            b_stage1 <= addb;
        end
        en_stage1 <= i_en;
        
        // Stage 2: Register inputs and compute both possible sums
        a_stage2 <= a_stage1;
        b_stage2 <= b_stage1;
        en_stage2 <= en_stage1;
        
        // Compute sums with carry=0 and carry=1 for each chunk
        sum0_0 <= {1'b0, chunk0_a} + {1'b0, chunk0_b};
        sum0_1 <= {1'b0, chunk0_a} + {1'b0, chunk0_b} + 1'b1;
        
        sum1_0 <= {1'b0, chunk1_a} + {1'b0, chunk1_b};
        sum1_1 <= {1'b0, chunk1_a} + {1'b0, chunk1_b} + 1'b1;
        
        sum2_0 <= {1'b0, chunk2_a} + {1'b0, chunk2_b};
        sum2_1 <= {1'b0, chunk2_a} + {1'b0, chunk2_b} + 1'b1;
        
        sum3_0 <= {1'b0, chunk3_a} + {1'b0, chunk3_b};
        sum3_1 <= {1'b0, chunk3_a} + {1'b0, chunk3_b} + 1'b1;
        
        // Stage 3: Resolve carries and select correct sums
        a_stage3 <= a_stage2;
        b_stage3 <= b_stage2;
        en_stage3 <= en_stage2;
        
        // Carry resolution
        carry1 <= sum0_0[CHUNK_SIZE] ? 1'b1 : sum0_1[CHUNK_SIZE];
        carry2 <= sum1_0[CHUNK_SIZE] ? 1'b1 : sum1_1[CHUNK_SIZE];
        carry3 <= sum2_0[CHUNK_SIZE] ? 1'b1 : sum2_1[CHUNK_SIZE];
        
        // Stage 4: Generate final result
        if (en_stage3) begin
            result <= {1'b0, a_stage3} + {1'b0, b_stage3};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule