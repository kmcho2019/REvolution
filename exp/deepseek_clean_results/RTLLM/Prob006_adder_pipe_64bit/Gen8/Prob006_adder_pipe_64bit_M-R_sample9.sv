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
reg [63:0] a_stage0, b_stage0;    // Stage 0 input registers
reg [15:0] sum_stage1, sum_stage2, sum_stage3, sum_stage4;
reg carry_stage1, carry_stage2, carry_stage3;
reg [3:0] enable_pipeline;

// Stage 0: Input registers and first 16-bit addition (combinational)
wire [16:0] sum_with_carry0 = {1'b0, adda[15:0]} + {1'b0, addb[15:0]};

// Stage 1: Second 16-bit addition with carry (combinational)
wire [16:0] sum_with_carry1 = {1'b0, a_stage0[31:16]} + {1'b0, b_stage0[31:16]} + carry_stage1;

// Stage 2: Third 16-bit addition with carry (combinational)
wire [16:0] sum_with_carry2 = {1'b0, a_stage0[47:32]} + {1'b0, b_stage0[47:32]} + carry_stage2;

// Stage 3: Final 16-bit addition with carry (combinational)
wire [16:0] sum_with_carry3 = {1'b0, a_stage0[63:48]} + {1'b0, b_stage0[63:48]} + carry_stage3;

// Pipeline stage 0: Input registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stage0 <= 64'b0;
        b_stage0 <= 64'b0;
        enable_pipeline[0] <= 1'b0;
    end else begin
        a_stage0 <= adda;
        b_stage0 <= addb;
        enable_pipeline[0] <= i_en;
    end
end

// Pipeline stage 1: First addition and carry
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1 <= 16'b0;
        carry_stage1 <= 1'b0;
        enable_pipeline[1] <= 1'b0;
    end else begin
        sum_stage1 <= sum_with_carry0[15:0];
        carry_stage1 <= sum_with_carry0[16];
        enable_pipeline[1] <= enable_pipeline[0];
    end
end

// Pipeline stage 2: Second addition and carry
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2 <= 16'b0;
        carry_stage2 <= 1'b0;
        enable_pipeline[2] <= 1'b0;
    end else begin
        sum_stage2 <= sum_with_carry1[15:0];
        carry_stage2 <= sum_with_carry1[16];
        enable_pipeline[2] <= enable_pipeline[1];
    end
end

// Pipeline stage 3: Third addition and carry
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage3 <= 16'b0;
        carry_stage3 <= 1'b0;
        enable_pipeline[3] <= 1'b0;
    end else begin
        sum_stage3 <= sum_with_carry2[15:0];
        carry_stage3 <= sum_with_carry2[16];
        enable_pipeline[3] <= enable_pipeline[2];
    end
end

// Pipeline stage 4: Final addition and result assembly
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage4 <= 16'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        sum_stage4 <= sum_with_carry3[15:0];
        // Proper 65-bit result concatenation: {final_carry, sum_stage4, sum_stage3, sum_stage2, sum_stage1}
        result <= {sum_with_carry3[16], sum_stage4, sum_stage3, sum_stage2, sum_stage1};
        o_en <= enable_pipeline[3];
    end
end

endmodule