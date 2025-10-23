module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline stage 1 registers
    reg [15:0] stage1_multiplicand;
    reg [15:0] stage1_multiplier;
    reg [15:0] stage1_m2;  // Precompute m*2
    reg stage1_valid;

    // Pipeline stage 2 registers
    reg [15:0] stage2_pp [0:3];  // Array for partial products
    reg stage2_valid;

    // Pipeline stage 3 registers (adder tree)
    reg [15:0] stage3_sum01, stage3_sum23;
    reg stage3_valid;

    // Final sum register
    reg [15:0] final_sum;

    // Clock gating signals
    wire stage2_clk_en = stage1_valid;
    wire stage3_clk_en = stage2_valid;
    wire output_clk_en = stage3_valid;

    // Booth encoder function (optimized)
    function [15:0] booth_encoder;
        input [2:0] bits;
        input [15:0] m;
        input [15:0] m2;
        begin
            case (bits)
                3'b000, 3'b111: booth_encoder = 16'b0;
                3'b001, 3'b010: booth_encoder = m;
                3'b011:         booth_encoder = m2;
                3'b100:         booth_encoder = -m2;
                default:        booth_encoder = -m; // 101,110
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all pipeline registers
            stage1_valid <= 1'b0;
            stage2_valid <= 1'b0;
            stage3_valid <= 1'b0;
            rdy <= 1'b0;
            p <= 16'b0;
        end else begin
            // Pipeline stage 1: Operand preparation
            stage1_multiplicand <= {{8{a[7]}}, a};
            stage1_multiplier <= {{8{b[7]}}, b};
            stage1_m2 <= {{8{a[7]}}, a} << 1;  // Precompute m*2
            stage1_valid <= 1'b1;

            // Pipeline stage 2: Booth encoding (clock gated)
            if (stage2_clk_en) begin
                // Generate all partial products in parallel
                stage2_pp[0] <= booth_encoder(
                    {stage1_multiplier[1:0], 1'b0}, 
                    stage1_multiplicand, 
                    stage1_m2
                );
                
                stage2_pp[1] <= booth_encoder(
                    {stage1_multiplier[3:2], stage1_multiplier[1]}, 
                    stage1_multiplicand, 
                    stage1_m2
                ) << 2;
                
                stage2_pp[2] <= booth_encoder(
                    {stage1_multiplier[5:4], stage1_multiplier[3]}, 
                    stage1_multiplicand, 
                    stage1_m2
                ) << 4;
                
                stage2_pp[3] <= booth_encoder(
                    {stage1_multiplier[7:6], stage1_multiplier[5]}, 
                    stage1_multiplicand, 
                    stage1_m2
                ) << 6;
                
                stage2_valid <= 1'b1;
            end else begin
                stage2_valid <= 1'b0;
            end

            // Pipeline stage 3: Balanced adder tree (clock gated)
            if (stage3_clk_en) begin
                stage3_sum01 <= stage2_pp[0] + stage2_pp[1];
                stage3_sum23 <= stage2_pp[2] + stage2_pp[3];
                stage3_valid <= 1'b1;
            end else begin
                stage3_valid <= 1'b0;
            end

            // Final addition and output (clock gated)
            if (output_clk_en) begin
                final_sum <= stage3_sum01 + stage3_sum23;
                p <= final_sum;
                rdy <= 1'b1;
            end else begin
                rdy <= 1'b0;
            end
        end
    end

endmodule