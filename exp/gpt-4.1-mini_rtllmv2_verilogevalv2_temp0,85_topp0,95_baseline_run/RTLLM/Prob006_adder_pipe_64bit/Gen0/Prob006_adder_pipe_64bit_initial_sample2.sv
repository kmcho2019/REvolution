module adder_pipe_64bit (
    input            clk,
    input            rst_n,
    input            i_en,
    input   [63:0]   adda,
    input   [63:0]   addb,
    output reg [64:0] result,
    output reg       o_en
);

    // Pipeline depth: 4 stages, each 16 bits
    // Registers for stage inputs
    reg            i_en_r1, i_en_r2, i_en_r3, i_en_r4;
    reg [15:0]     adda_r1, adda_r2, adda_r3, adda_r4;
    reg [15:0]     addb_r1, addb_r2, addb_r3, addb_r4;

    // Carry and sum registers between stages
    reg            carry_r1, carry_r2, carry_r3;

    // Sum outputs of each stage
    reg [15:0]     sum_r1, sum_r2, sum_r3, sum_r4;

    // Stage 1: bits [15:0]
    wire [16:0] stage1_sum = {1'b0, adda[15:0]} + {1'b0, addb[15:0]};

    // Stage 2: bits [31:16]
    wire [16:0] stage2_sum;
    // Stage 3: bits [47:32]
    wire [16:0] stage3_sum;
    // Stage 4: bits [63:48]
    wire [16:0] stage4_sum;

    // Stage 2 inputs
    wire [15:0] stage2_adda = adda[31:16];
    wire [15:0] stage2_addb = addb[31:16];
    // Stage 3 inputs
    wire [15:0] stage3_adda = adda[47:32];
    wire [15:0] stage3_addb = addb[47:32];
    // Stage 4 inputs
    wire [15:0] stage4_adda = adda[63:48];
    wire [15:0] stage4_addb = addb[63:48];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            i_en_r1 <= 1'b0;
            i_en_r2 <= 1'b0;
            i_en_r3 <= 1'b0;
            i_en_r4 <= 1'b0;

            adda_r1 <= 16'b0;
            adda_r2 <= 16'b0;
            adda_r3 <= 16'b0;
            adda_r4 <= 16'b0;

            addb_r1 <= 16'b0;
            addb_r2 <= 16'b0;
            addb_r3 <= 16'b0;
            addb_r4 <= 16'b0;

            carry_r1 <= 1'b0;
            carry_r2 <= 1'b0;
            carry_r3 <= 1'b0;

            sum_r1 <= 16'b0;
            sum_r2 <= 16'b0;
            sum_r3 <= 16'b0;
            sum_r4 <= 16'b0;

            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 1 inputs and enable register
            i_en_r1 <= i_en;
            adda_r1 <= adda[31:16];   // for stage2
            addb_r1 <= addb[31:16];   // for stage2

            // Compute stage 1 sum
            sum_r1 <= stage1_sum[15:0];
            carry_r1 <= stage1_sum[16];

            // Stage 2 inputs and enable register
            i_en_r2 <= i_en_r1;
            adda_r2 <= adda[47:32];   // for stage3
            addb_r2 <= addb[47:32];   // for stage3

            // Compute stage 2 sum with carry from stage 1
            stage2_sum <= {1'b0, adda_r1} + {1'b0, addb_r1} + carry_r1;
            sum_r2 <= stage2_sum[15:0];
            carry_r2 <= stage2_sum[16];

            // Stage 3 inputs and enable register
            i_en_r3 <= i_en_r2;
            adda_r3 <= adda[63:48];   // for stage4
            addb_r3 <= addb[63:48];   // for stage4

            // Compute stage 3 sum with carry from stage 2
            stage3_sum <= {1'b0, adda_r2} + {1'b0, addb_r2} + carry_r2;
            sum_r3 <= stage3_sum[15:0];
            carry_r3 <= stage3_sum[16];

            // Stage 4 inputs and enable register
            i_en_r4 <= i_en_r3;
            adda_r4 <= 16'b0;  // no next stage
            addb_r4 <= 16'b0;  // no next stage

            // Compute stage 4 sum with carry from stage 3
            stage4_sum <= {1'b0, adda_r3} + {1'b0, addb_r3} + carry_r3;
            sum_r4 <= stage4_sum[15:0];

            // Result assembly
            result <= {stage4_sum[16], sum_r4, sum_r3, sum_r2, sum_r1};

            // Output enable propagation
            o_en <= i_en_r4;
        end
    end

endmodule