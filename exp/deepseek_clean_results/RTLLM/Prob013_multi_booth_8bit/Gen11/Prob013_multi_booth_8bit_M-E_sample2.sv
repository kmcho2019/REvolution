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
    reg stage1_valid;

    // Pipeline stage 2 registers
    reg [15:0] stage2_pp0, stage2_pp1, stage2_pp2, stage2_pp3;
    reg stage2_valid;

    // Pipeline stage 3 registers
    reg [15:0] stage3_sum;
    reg stage3_valid;

    // Booth encoder functions
    function [15:0] booth_encoder;
        input [2:0] bits;
        input [15:0] m;
        input [15:0] m2;
        begin
            case (bits)
                3'b000, 3'b111: booth_encoder = 16'b0;
                3'b001, 3'b010: booth_encoder = m;
                3'b011: booth_encoder = m2;
                3'b100: booth_encoder = ~m2 + 1'b1;
                default: booth_encoder = ~m + 1'b1; // 101,110
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
            stage1_valid <= 1'b1;

            // Pipeline stage 2: Booth encoding
            if (stage1_valid) begin
                // Precompute multiplicand * 2
                reg [15:0] m2;
                m2 = {stage1_multiplicand[14:0], 1'b0};
                
                // Generate all partial products in parallel
                stage2_pp0 = booth_encoder(
                    {stage1_multiplier[1:0], 1'b0}, 
                    stage1_multiplicand, 
                    m2
                );
                
                stage2_pp1 = booth_encoder(
                    {stage1_multiplier[3:2], stage1_multiplier[1]}, 
                    stage1_multiplicand, 
                    m2
                ) << 2;
                
                stage2_pp2 = booth_encoder(
                    {stage1_multiplier[5:4], stage1_multiplier[3]}, 
                    stage1_multiplicand, 
                    m2
                ) << 4;
                
                stage2_pp3 = booth_encoder(
                    {stage1_multiplier[7:6], stage1_multiplier[5]}, 
                    stage1_multiplicand, 
                    m2
                ) << 6;
                
                stage2_valid <= 1'b1;
            end else begin
                stage2_valid <= 1'b0;
            end

            // Pipeline stage 3: Accumulation
            if (stage2_valid) begin
                stage3_sum <= stage2_pp0 + stage2_pp1 + stage2_pp2 + stage2_pp3;
                stage3_valid <= 1'b1;
            end else begin
                stage3_valid <= 1'b0;
            end

            // Output stage
            if (stage3_valid) begin
                p <= stage3_sum;
                rdy <= 1'b1;
            end else begin
                rdy <= 1'b0;
            end
        end
    end

endmodule