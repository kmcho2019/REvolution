module adder_pipe_64bit(
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Split input operands into 4 chunks of 16 bits each
    wire [15:0] a0 = adda[15:0];
    wire [15:0] a1 = adda[31:16];
    wire [15:0] a2 = adda[47:32];
    wire [15:0] a3 = adda[63:48];

    wire [15:0] b0 = addb[15:0];
    wire [15:0] b1 = addb[31:16];
    wire [15:0] b2 = addb[47:32];
    wire [15:0] b3 = addb[63:48];

    // Pipeline registers for inputs at each stage
    reg [15:0] a0_reg1, b0_reg1;
    reg [15:0] a1_reg1, b1_reg1;
    reg [15:0] a2_reg1, b2_reg1;
    reg [15:0] a3_reg1, b3_reg1;

    reg [15:0] a1_reg2, b1_reg2;
    reg [15:0] a2_reg2, b2_reg2;
    reg [15:0] a3_reg2, b3_reg2;

    reg [15:0] a2_reg3, b2_reg3;
    reg [15:0] a3_reg3, b3_reg3;

    reg [15:0] a3_reg4, b3_reg4;

    // Pipeline registers for carries between stages
    reg        carry0_reg1; // carry-in to stage 1 (always 0)
    reg        carry1_reg2;
    reg        carry2_reg3;
    reg        carry3_reg4;

    // Pipeline registers for sums output of each adder stage
    reg [15:0] sum0_reg1;
    reg [15:0] sum1_reg2;
    reg [15:0] sum2_reg3;
    reg [15:0] sum3_reg4;

    // Pipeline register for enable signals (5 stages: input + 4 adders)
    reg [4:0] en_pipe;

    // Ripple carry adder 16-bit combinational module definition
    // Inputs: a,b (16-bit), cin (1-bit)
    // Outputs: sum(16-bit), cout(1-bit)
    wire [16:0] rc_sum0, rc_sum1, rc_sum2, rc_sum3;

    ripple_carry_16 rc0(
        .a(a0_reg1),
        .b(b0_reg1),
        .cin(carry0_reg1),
        .sum(rc_sum0)
    );

    ripple_carry_16 rc1(
        .a(a1_reg2),
        .b(b1_reg2),
        .cin(carry1_reg2),
        .sum(rc_sum1)
    );

    ripple_carry_16 rc2(
        .a(a2_reg3),
        .b(b2_reg3),
        .cin(carry2_reg3),
        .sum(rc_sum2)
    );

    ripple_carry_16 rc3(
        .a(a3_reg4),
        .b(b3_reg4),
        .cin(carry3_reg4),
        .sum(rc_sum3)
    );

    // Register pipeline and control logic
    always @(posedge clk) begin
        if (!rst_n) begin
            // Clear all pipeline registers
            a0_reg1 <= 16'd0; b0_reg1 <= 16'd0; carry0_reg1 <= 1'b0;
            a1_reg1 <= 16'd0; b1_reg1 <= 16'd0;
            a1_reg2 <= 16'd0; b1_reg2 <= 16'd0; carry1_reg2 <= 1'b0;
            a2_reg1 <= 16'd0; b2_reg1 <= 16'd0;
            a2_reg2 <= 16'd0; b2_reg2 <= 16'd0;
            a2_reg3 <= 16'd0; b2_reg3 <= 16'd0; carry2_reg3 <= 1'b0;
            a3_reg1 <= 16'd0; b3_reg1 <= 16'd0;
            a3_reg2 <= 16'd0; b3_reg2 <= 16'd0;
            a3_reg3 <= 16'd0; b3_reg3 <= 16'd0;
            a3_reg4 <= 16'd0; b3_reg4 <= 16'd0; carry3_reg4 <= 1'b0;

            sum0_reg1 <= 16'd0;
            sum1_reg2 <= 16'd0;
            sum2_reg3 <= 16'd0;
            sum3_reg4 <= 16'd0;

            en_pipe <= 5'b0;

            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Input registers stage 1 (register input operands when i_en asserted)
            if (i_en) begin
                a0_reg1 <= a0;
                b0_reg1 <= b0;
                carry0_reg1 <= 1'b0;  // Initial carry in zero
                a1_reg1 <= a1;
                b1_reg1 <= b1;
                a2_reg1 <= a2;
                b2_reg1 <= b2;
                a3_reg1 <= a3;
                b3_reg1 <= b3;
            end else begin
                // Hold previous values if no new input enable
                a0_reg1 <= a0_reg1;
                b0_reg1 <= b0_reg1;
                carry0_reg1 <= carry0_reg1;
                a1_reg1 <= a1_reg1;
                b1_reg1 <= b1_reg1;
                a2_reg1 <= a2_reg1;
                b2_reg1 <= b2_reg1;
                a3_reg1 <= a3_reg1;
                b3_reg1 <= b3_reg1;
            end

            // Stage 1: latch sum0 and propagate carry to stage 2 input registers
            sum0_reg1 <= rc_sum0[15:0];
            carry1_reg2 <= rc_sum0[16];

            // Move a1,b1 and carry1 to stage 2 registers
            a1_reg2 <= a1_reg1;
            b1_reg2 <= b1_reg1;

            // Stage 2: latch sum1 and propagate carry to stage 3 input registers
            sum1_reg2 <= rc_sum1[15:0];
            carry2_reg3 <= rc_sum1[16];

            // Move a2,b2 to stage 2 and then stage 3 registers
            a2_reg2 <= a2_reg1;
            b2_reg2 <= b2_reg1;
            a2_reg3 <= a2_reg2;
            b2_reg3 <= b2_reg2;

            // Stage 3: latch sum2 and propagate carry to stage 4 input registers
            sum2_reg3 <= rc_sum2[15:0];
            carry3_reg4 <= rc_sum2[16];

            // Move a3,b3 to stage 3 and then stage 4 registers
            a3_reg2 <= a3_reg1;
            b3_reg2 <= b3_reg1;
            a3_reg3 <= a3_reg2;
            b3_reg3 <= b3_reg2;
            a3_reg4 <= a3_reg3;
            b3_reg4 <= b3_reg3;

            // Stage 4: latch sum3 (final 16 bits)
            sum3_reg4 <= rc_sum3[15:0];

            // Advance enable pipeline
            en_pipe <= {en_pipe[3:0], i_en};

            // Output result when pipeline data valid (after 4 stages)
            if (en_pipe[4]) begin
                // Concatenate all sum pieces and carry out
                result <= {rc_sum3[16], sum3_reg4, sum2_reg3, sum1_reg2, sum0_reg1};
            end else begin
                result <= result;
            end

            o_en <= en_pipe[4];
        end
    end

endmodule


// 16-bit ripple carry adder module: combinational
module ripple_carry_16(
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        cin,
    output wire [16:0] sum  // [15:0] sum bits, [16] carry out
);
    wire [16:0] c;
    wire [15:0] s;

    assign c[0] = cin;
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : gen_rca_bits
            assign s[i] = a[i] ^ b[i] ^ c[i];
            assign c[i+1] = (a[i]&b[i]) | (a[i]&c[i]) | (b[i]&c[i]);
        end
    endgenerate

    assign sum = {c[16], s};

endmodule