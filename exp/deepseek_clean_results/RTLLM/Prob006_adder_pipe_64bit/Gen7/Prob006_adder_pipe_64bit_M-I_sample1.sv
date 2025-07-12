module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [63:0] a_reg, b_reg;          // Stage 0: Input registers
reg [15:0] sum0, sum1, sum2, sum3; // Partial sums for each stage
reg carry0, carry1, carry2;        // Carry between stages
reg [3:0] en_pipe;                 // Enable pipeline

// Stage 0: Input registers and first 16-bit addition
wire [16:0] stage0_sum = {1'b0, adda[15:0]} + {1'b0, addb[15:0]};

// Stage 1: Second 16-bit addition with carry
wire [16:0] stage1_sum = {1'b0, a_reg[31:16]} + {1'b0, b_reg[31:16]} + carry0;

// Stage 2: Third 16-bit addition with carry
wire [16:0] stage2_sum = {1'b0, a_reg[47:32]} + {1'b0, b_reg[47:32]} + carry1;

// Stage 3: Final 16-bit addition with carry
wire [16:0] stage3_sum = {1'b0, a_reg[63:48]} + {1'b0, b_reg[63:48]} + carry2;

// Pipeline control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        a_reg <= 64'b0;
        b_reg <= 64'b0;
        sum0 <= 16'b0;
        sum1 <= 16'b0;
        sum2 <= 16'b0;
        sum3 <= 16'b0;
        carry0 <= 1'b0;
        carry1 <= 1'b0;
        carry2 <= 1'b0;
        en_pipe <= 4'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 0: Register inputs and compute first sum
        a_reg <= adda;
        b_reg <= addb;
        sum0 <= stage0_sum[15:0];
        carry0 <= stage0_sum[16];
        en_pipe[0] <= i_en;

        // Stage 1: Compute second sum with carry
        sum1 <= stage1_sum[15:0];
        carry1 <= stage1_sum[16];
        en_pipe[1] <= en_pipe[0];

        // Stage 2: Compute third sum with carry
        sum2 <= stage2_sum[15:0];
        carry2 <= stage2_sum[16];
        en_pipe[2] <= en_pipe[1];

        // Stage 3: Compute final sum and combine result
        sum3 <= stage3_sum[15:0];
        result <= {stage3_sum, sum2, sum1, sum0}; // 65-bit result
        en_pipe[3] <= en_pipe[2];
        
        // Output enable is last stage of enable pipeline
        o_en <= en_pipe[3];
    end
end

endmodule