module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Clock gating signals
    wire stage1_clk, stage2_clk, stage3_clk;

    // Pipeline stage 1 registers
    reg [15:0] stage1_multiplicand;
    reg [15:0] stage1_multiplier;
    reg [15:0] stage1_m2;  // Precompute m*2 here
    reg stage1_valid;

    // Pipeline stage 2 registers
    reg [15:0] stage2_pp [0:3];  // Array for partial products
    reg stage2_valid;

    // Pipeline stage 3 registers (carry-save format)
    reg [15:0] stage3_sum0, stage3_sum1;
    reg stage3_valid;

    // Final adder stage
    reg [15:0] final_sum;
    reg final_valid;

    // Clock gating
    assign stage1_clk = clk & (~reset);
    assign stage2_clk = clk & stage1_valid;
    assign stage3_clk = clk & stage2_valid;

    // Shared Booth encoder logic
    function [15:0] booth_encoder;
        input [2:0] bits;
        input [15:0] m;
        input [15:0] m2;
        input [15:0] m_neg;
        input [15:0] m2_neg;
        begin
            case (bits)
                3'b000, 3'b111: booth_encoder = 16'b0;
                3'b001, 3'b010: booth_encoder = m;
                3'b011: booth_encoder = m2;
                3'b100: booth_encoder = m2_neg;
                default: booth_encoder = m_neg; // 101,110
            endcase
        end
    endfunction

    always @(posedge stage1_clk or posedge reset) begin
        if (reset) begin
            stage1_valid <= 1'b0;
            stage1_multiplicand <= 16'b0;
            stage1_multiplier <= 16'b0;
            stage1_m2 <= 16'b0;
        end else begin
            // Stage 1: Operand preparation with precomputed m2
            stage1_multiplicand <= {{8{a[7]}}, a};
            stage1_multiplier <= {{8{b[7]}}, b};
            stage1_m2 <= {{7{a[7]}}, a, 1'b0};  // m*2 with proper sign extension
            stage1_valid <= 1'b1;
        end
    end

    always @(posedge stage2_clk) begin
        // Precompute negative values once
        reg [15:0] m_neg, m2_neg;
        m_neg = ~stage1_multiplicand + 1'b1;
        m2_neg = ~stage1_m2 + 1'b1;

        // Generate partial products with shared logic
        stage2_pp[0] <= booth_encoder(
            {stage1_multiplier[1:0], 1'b0},
            stage1_multiplicand,
            stage1_m2,
            m_neg,
            m2_neg
        );
        
        stage2_pp[1] <= booth_encoder(
            {stage1_multiplier[3:2], stage1_multiplier[1]},
            stage1_multiplicand,
            stage1_m2,
            m_neg,
            m2_neg
        ) << 2;
        
        stage2_pp[2] <= booth_encoder(
            {stage1_multiplier[5:4], stage1_multiplier[3]},
            stage1_multiplicand,
            stage1_m2,
            m_neg,
            m2_neg
        ) << 4;
        
        stage2_pp[3] <= booth_encoder(
            {stage1_multiplier[7:6], stage1_multiplier[5]},
            stage1_multiplicand,
            stage1_m2,
            m_neg,
            m2_neg
        ) << 6;
        
        stage2_valid <= stage1_valid;
    end

    always @(posedge stage3_clk) begin
        // Carry-save adder tree (2 levels)
        reg [15:0] sum01, sum23;
        sum01 = stage2_pp[0] + stage2_pp[1];
        sum23 = stage2_pp[2] + stage2_pp[3];
        
        stage3_sum0 <= sum01;
        stage3_sum1 <= sum23;
        stage3_valid <= stage2_valid;
    end

    always @(posedge clk) begin
        if (stage3_valid) begin
            // Final addition in separate stage
            final_sum <= stage3_sum0 + stage3_sum1;
            final_valid <= 1'b1;
        end else begin
            final_valid <= 1'b0;
        end

        // Output stage
        p <= final_valid ? final_sum : 16'b0;
        rdy <= final_valid;
    end

endmodule