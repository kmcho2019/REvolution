module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Pipeline depth = 4 stages
    // Stage 1 inputs registers: entire 64-bit operands
    reg [63:0] adda_r1, addb_r1;

    // Stage 2 input registers: upper 48 bits sliced and registered in two steps
    // For stage 1 addition of lower 16 bits
    wire [15:0] a0 = adda_r1[15:0];
    wire [15:0] b0 = addb_r1[15:0];

    // Stage 2 registers: next 16 bits
    reg [15:0] a1_r2, b1_r2;

    // Stage 3 registers: next 16 bits
    reg [15:0] a2_r3, b2_r3;

    // Stage 4 registers: highest 16 bits
    reg [15:0] a3_r4, b3_r4;

    // Stage 1 RCA outputs (lower 16 bits + carry)
    wire [16:0] sum0;
    reg  [15:0] sum0_r;
    reg         c1_r;

    // Stage 2 RCA outputs
    wire [16:0] sum1;
    reg  [15:0] sum1_r;
    reg         c2_r;

    // Stage 3 RCA outputs
    wire [16:0] sum2;
    reg  [15:0] sum2_r;
    reg         c3_r;

    // Stage 4 RCA outputs
    wire [16:0] sum3;
    reg  [15:0] sum3_r;
    reg         c4_r;

    // Pipeline enable shift register for 4-stage latency
    reg [3:0] en_pipe;

    // Stage 1 RCA: lower 16 bits with cin=0
    ripple_carry_16 u_rca0 (
        .a(a0),
        .b(b0),
        .cin(1'b0),
        .sum(sum0)
    );

    // Stage 2 RCA: bits [31:16] + carry from stage 1
    ripple_carry_16 u_rca1 (
        .a(a1_r2),
        .b(b1_r2),
        .cin(c1_r),
        .sum(sum1)
    );

    // Stage 3 RCA: bits [47:32] + carry from stage 2
    ripple_carry_16 u_rca2 (
        .a(a2_r3),
        .b(b2_r3),
        .cin(c2_r),
        .sum(sum2)
    );

    // Stage 4 RCA: bits [63:48] + carry from stage 3
    ripple_carry_16 u_rca3 (
        .a(a3_r4),
        .b(b3_r4),
        .cin(c3_r),
        .sum(sum3)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_r1 <= 64'd0;
            addb_r1 <= 64'd0;

            a1_r2 <= 16'd0;
            b1_r2 <= 16'd0;

            a2_r3 <= 16'd0;
            b2_r3 <= 16'd0;

            a3_r4 <= 16'd0;
            b3_r4 <= 16'd0;

            sum0_r <= 16'd0;
            c1_r <= 1'b0;

            sum1_r <= 16'd0;
            c2_r <= 1'b0;

            sum2_r <= 16'd0;
            c3_r <= 1'b0;

            sum3_r <= 16'd0;
            c4_r <= 1'b0;

            en_pipe <= 4'b0;

            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Stage 1: register inputs if i_en asserted
            if (i_en) begin
                adda_r1 <= adda;
                addb_r1 <= addb;
            end

            // Stage 1 outputs registered
            sum0_r <= sum0[15:0];
            c1_r   <= sum0[16];

            // Stage 2 input registers: next 16 bits (bits 31:16)
            // Register stage 1 operands' bits [31:16]
            a1_r2 <= adda_r1[31:16];
            b1_r2 <= addb_r1[31:16];

            // Stage 2 outputs registered
            sum1_r <= sum1[15:0];
            c2_r   <= sum1[16];

            // Stage 3 input registers: bits [47:32]
            a2_r3 <= adda_r1[47:32];
            b2_r3 <= addb_r1[47:32];

            // Stage 3 outputs registered
            sum2_r <= sum2[15:0];
            c3_r   <= sum2[16];

            // Stage 4 input registers: bits [63:48]
            a3_r4 <= adda_r1[63:48];
            b3_r4 <= addb_r1[63:48];

            // Stage 4 outputs registered
            sum3_r <= sum3[15:0];
            c4_r   <= sum3[16];

            // Shift enable pipeline to track when output is valid
            en_pipe <= {en_pipe[2:0], i_en};

            // Output result and output enable when pipeline completes
            if (en_pipe[3]) begin
                result <= {c4_r, sum3_r, sum2_r, sum1_r, sum0_r};
                o_en <= 1'b1;
            end else begin
                o_en <= 1'b0;
            end
        end
    end

endmodule

// 16-bit ripple carry adder combinational module
module ripple_carry_16 (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        cin,
    output wire [16:0] sum  // sum[15:0] + carry out sum[16]
);
    wire [16:0] c;
    wire [15:0] s;

    assign c[0] = cin;
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_rca
            assign s[i] = a[i] ^ b[i] ^ c[i];
            assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
        end
    endgenerate

    assign sum = {c[16], s};
endmodule