module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Split inputs into 16-bit chunks
    wire [15:0] a0 = adda[15:0];
    wire [15:0] a1 = adda[31:16];
    wire [15:0] a2 = adda[47:32];
    wire [15:0] a3 = adda[63:48];

    wire [15:0] b0 = addb[15:0];
    wire [15:0] b1 = addb[31:16];
    wire [15:0] b2 = addb[47:32];
    wire [15:0] b3 = addb[63:48];

    // Pipeline stage 1 registers: inputs and carry-in=0
    reg [15:0] a0_r, b0_r;
    reg [15:0] a1_r, b1_r;

    // Stage 1 outputs
    wire [16:0] sum0;  // 16-bit sum + carry out
    reg  [15:0] sum0_r;
    reg         c1_r;

    // Pipeline stage 2 registers
    reg [15:0] a2_r, b2_r;
    reg [15:0] a1_r2, b1_r2;

    // Stage 2 outputs
    wire [16:0] sum1;
    reg  [15:0] sum1_r;
    reg         c2_r;

    // Pipeline stage 3 registers
    reg [15:0] a3_r, b3_r;
    reg [15:0] a2_r2, b2_r2;

    // Stage 3 outputs
    wire [16:0] sum2;
    reg  [15:0] sum2_r;
    reg         c3_r;

    // Pipeline stage 4 registers
    reg [15:0] a3_r2, b3_r2;

    // Stage 4 outputs
    wire [16:0] sum3;
    reg  [15:0] sum3_r;
    reg         c4_r;

    // Enable pipeline (4 stages)
    reg [3:0] en_pipe;

    // 16-bit ripple carry adder combinational module instance
    ripple_carry_16 u_rca0 (.a(a0_r),   .b(b0_r),   .cin(1'b0), .sum(sum0));
    ripple_carry_16 u_rca1 (.a(a1_r2),  .b(b1_r2),  .cin(c1_r), .sum(sum1));
    ripple_carry_16 u_rca2 (.a(a2_r2),  .b(b2_r2),  .cin(c2_r), .sum(sum2));
    ripple_carry_16 u_rca3 (.a(a3_r2),  .b(b3_r2),  .cin(c3_r), .sum(sum3));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers and outputs
            a0_r <= 16'd0; b0_r <= 16'd0;
            a1_r <= 16'd0; b1_r <= 16'd0;
            a1_r2 <= 16'd0; b1_r2 <= 16'd0;
            a2_r <= 16'd0; b2_r <= 16'd0;
            a2_r2 <= 16'd0; b2_r2 <= 16'd0;
            a3_r <= 16'd0; b3_r <= 16'd0;
            a3_r2 <= 16'd0; b3_r2 <= 16'd0;

            sum0_r <= 16'd0; c1_r <= 1'b0;
            sum1_r <= 16'd0; c2_r <= 1'b0;
            sum2_r <= 16'd0; c3_r <= 1'b0;
            sum3_r <= 16'd0; c4_r <= 1'b0;

            en_pipe <= 4'b0;

            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Stage 1 input registers (when i_en active)
            if (i_en) begin
                a0_r <= a0;
                b0_r <= b0;
                a1_r <= a1;
                b1_r <= b1;
            end

            // Stage 1 outputs registered
            sum0_r <= sum0[15:0];
            c1_r   <= sum0[16];

            // Stage 2 input registers (a1,b1 plus carry from stage 1)
            a1_r2 <= a1_r;
            b1_r2 <= b1_r;

            // Stage 2 inputs also latched when i_en delayed by one cycle
            if (en_pipe[0]) begin
                a2_r <= a2;
                b2_r <= b2;
            end

            // Stage 2 outputs registered
            sum1_r <= sum1[15:0];
            c2_r   <= sum1[16];

            // Stage 3 input registers (a2,b2 plus carry from stage 2)
            a2_r2 <= a2_r;
            b2_r2 <= b2_r;

            if (en_pipe[1]) begin
                a3_r <= a3;
                b3_r <= b3;
            end

            // Stage 3 outputs registered
            sum2_r <= sum2[15:0];
            c3_r   <= sum2[16];

            // Stage 4 input registers (a3,b3 plus carry from stage 3)
            a3_r2 <= a3_r;
            b3_r2 <= b3_r;

            // Stage 4 outputs registered
            sum3_r <= sum3[15:0];
            c4_r   <= sum3[16];

            // Shift enable pipeline
            en_pipe <= {en_pipe[2:0], i_en};

            // Output result and valid signal when pipeline completes (4 cycles)
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