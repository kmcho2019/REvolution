module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable shift register (5 bits: input + 4 pipeline stages)
    reg [4:0] mul_en_pipe;

    // Stage 0 registers: inputs
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products (combinational wires)
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i +1) begin : gen_partial_products
            assign pp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Stage 1: Carry Save Addition (CSA) of partial products into two sums (sum and carry)
    // CSA sums 8 operands by grouping pairs
    reg [15:0] csa1_sum, csa1_carry;
    wire [15:0] csa1_sum_w, csa1_carry_w;

    // Temporary wires for CSA stage 1 pairwise sums and carries
    wire [15:0] s0, c0, s1, c1, s2, c2, s3, c3;

    // CSA function: for each bit position, sum bits and output sum and carry bits
    // We'll implement CSA via bitwise operations:
    // sum = a ^ b ^ c
    // carry = (a&b) | (b&c) | (c&a)
    // Here we treat 3 operands at a time.

    // First level CSA: group partial products into triplets (3 operands)
    // For 8 operands: group as (pp0,pp1,pp2), (pp3,pp4,pp5), (pp6,pp7,0)
    // For last group, 0 padded.

    wire [15:0] pp6_padded = pp[6];
    wire [15:0] zero_16 = 16'b0;

    // CSA helper function: defined as combinational logic below

    // Compute CSA for first group: pp0, pp1, pp2
    wire [15:0] s_012 = pp[0] ^ pp[1] ^ pp[2];
    wire [15:0] c_012 = ((pp[0] & pp[1]) | (pp[1] & pp[2]) | (pp[2] & pp[0])) << 1;

    // Compute CSA for second group: pp3, pp4, pp5
    wire [15:0] s_345 = pp[3] ^ pp[4] ^ pp[5];
    wire [15:0] c_345 = ((pp[3] & pp[4]) | (pp[4] & pp[5]) | (pp[5] & pp[3])) << 1;

    // Compute CSA for third group: pp6, pp7, 0
    wire [15:0] s_67 = pp[6] ^ pp[7] ^ zero_16;
    wire [15:0] c_67 = ((pp[6] & pp[7]) | (pp[7] & zero_16) | (zero_16 & pp[6])) << 1;

    // Stage 2: CSA of sums and carries from stage 1
    // Inputs: s_012, c_012, s_345, c_345, s_67, c_67
    // Group as triplets to reduce to two operands

    // First CSA stage 2 group: s_012, c_012, s_345
    wire [15:0] s_stage2_0 = s_012 ^ c_012 ^ s_345;
    wire [15:0] c_stage2_0 = ((s_012 & c_012) | (c_012 & s_345) | (s_345 & s_012)) << 1;

    // Second CSA stage 2 group: c_345, s_67, c_67
    wire [15:0] s_stage2_1 = c_345 ^ s_67 ^ c_67;
    wire [15:0] c_stage2_1 = ((c_345 & s_67) | (s_67 & c_67) | (c_67 & c_345)) << 1;

    // Stage 3: Final addition of two operands from CSA stage 2 results
    // sum = s_stage2_0 + c_stage2_0 + s_stage2_1 + c_stage2_1
    // We'll add s_stage2_0 + c_stage2_0, then add s_stage2_1 + c_stage2_1, then sum both sums.

    // To pipeline properly, register intermediate sums

    // Stage 1 registers (hold CSA stage 1 outputs)
    reg [15:0] s_012_reg, c_012_reg;
    reg [15:0] s_345_reg, c_345_reg;
    reg [15:0] s_67_reg,  c_67_reg;

    // Stage 2 registers (hold CSA stage 2 outputs)
    reg [15:0] s_stage2_0_reg, c_stage2_0_reg;
    reg [15:0] s_stage2_1_reg, c_stage2_1_reg;

    // Stage 3 registers (final sum operands)
    reg [15:0] final_op_a_reg, final_op_b_reg;

    // Pipeline enable shift register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 5'b0;
        else
            mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
    end

    // Stage 0: register inputs when mul_en_in is asserted
    always @(posedge clk) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 1: register CSA stage 1 outputs (clock enabled)
    always @(posedge clk) begin
        if (!rst_n) begin
            s_012_reg <= 16'b0;
            c_012_reg <= 16'b0;
            s_345_reg <= 16'b0;
            c_345_reg <= 16'b0;
            s_67_reg  <= 16'b0;
            c_67_reg  <= 16'b0;
        end else if (mul_en_pipe[1]) begin
            s_012_reg <= s_012;
            c_012_reg <= c_012;
            s_345_reg <= s_345;
            c_345_reg <= c_345;
            s_67_reg  <= s_67;
            c_67_reg  <= c_67;
        end
    end

    // Stage 2: register CSA stage 2 outputs (clock enabled)
    always @(posedge clk) begin
        if (!rst_n) begin
            s_stage2_0_reg <= 16'b0;
            c_stage2_0_reg <= 16'b0;
            s_stage2_1_reg <= 16'b0;
            c_stage2_1_reg <= 16'b0;
        end else if (mul_en_pipe[2]) begin
            // Compute CSA sums from stage 1 registered outputs
            s_stage2_0_reg <= s_012_reg ^ c_012_reg ^ s_345_reg;
            c_stage2_0_reg <= ((s_012_reg & c_012_reg) | (c_012_reg & s_345_reg) | (s_345_reg & s_012_reg)) << 1;

            s_stage2_1_reg <= c_345_reg ^ s_67_reg ^ c_67_reg;
            c_stage2_1_reg <= ((c_345_reg & s_67_reg) | (s_67_reg & c_67_reg) | (c_67_reg & c_345_reg)) << 1;
        end
    end

    // Stage 3: register final operands for ripple carry adder (clock enabled)
    always @(posedge clk) begin
        if (!rst_n) begin
            final_op_a_reg <= 16'b0;
            final_op_b_reg <= 16'b0;
        end else if (mul_en_pipe[3]) begin
            final_op_a_reg <= s_stage2_0_reg + c_stage2_0_reg;
            final_op_b_reg <= s_stage2_1_reg + c_stage2_1_reg;
        end
    end

    // Final Stage 4: compute final product output by adding two operands
    reg [15:0] mul_out_reg;
    always @(posedge clk) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
        end else if (mul_en_pipe[4]) begin
            mul_out_reg <= final_op_a_reg + final_op_b_reg;
        end
    end

    // Output enable assigned from MSB of enable pipeline
    assign mul_en_out = mul_en_pipe[4];

    // Output mux: output valid product only when mul_en_out is asserted
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule