module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage1_multiplicand, stage1_multiplier;
    reg [15:0] stage2_multiplicand, stage2_multiplier;
    reg [15:0] stage3_accumulator;
    reg [2:0] stage_ctr;
    
    // Booth encoding signals
    wire [2:0] booth_group;
    wire [15:0] partial_product;
    wire [15:0] multiplicand_2x;
    
    // Control signals
    wire [1:0] cycle_count;
    wire last_cycle;
    
    // Sign extension
    wire [15:0] a_ext = {{8{a[7]}}, a};
    wire [15:0] b_ext = {{8{b[7]}}, b};
    
    // Booth group selection (overlapping 3 bits)
    assign booth_group = {stage2_multiplier[1:0], stage2_prev_bit};
    
    // 2x multiplicand (for ±2 operations)
    assign multiplicand_2x = stage2_multiplicand << 1;
    
    // Booth encoder and partial product selector
    always @(*) begin
        case (booth_group)
            3'b000, 3'b111: partial_product = 16'b0;        // 0
            3'b001, 3'b010: partial_product = stage2_multiplicand;  // +1
            3'b011:         partial_product = multiplicand_2x;      // +2
            3'b100:         partial_product = ~multiplicand_2x + 1; // -2
            3'b101, 3'b110: partial_product = ~stage2_multiplicand + 1; // -1
        endcase
    end
    
    // Cycle counter
    assign cycle_count = stage_ctr[1:0];
    assign last_cycle = (cycle_count == 2'b11);
    
    always @(posedge clk) begin
        if (reset) begin
            // Stage 1 initialization
            stage1_multiplicand <= a_ext;
            stage1_multiplier <= b_ext;
            
            // Stage 2 initialization
            stage2_multiplicand <= 16'b0;
            stage2_multiplier <= 16'b0;
            stage2_prev_bit <= 1'b0;
            
            // Stage 3 initialization
            stage3_accumulator <= 16'b0;
            p <= 16'b0;
            rdy <= 1'b0;
            stage_ctr <= 3'b0;
        end else begin
            // Pipeline stage 1: operand preparation
            stage1_multiplicand <= a_ext;
            stage1_multiplier <= b_ext;
            
            // Pipeline stage 2: Booth encoding
            stage2_multiplicand <= stage1_multiplicand << (2*cycle_count);
            stage2_multiplier <= stage1_multiplier >> (2*cycle_count);
            stage2_prev_bit <= stage1_multiplier[2*cycle_count];
            
            // Pipeline stage 3: accumulation
            if (stage_ctr < 4) begin
                stage3_accumulator <= stage3_accumulator + partial_product;
                stage_ctr <= stage_ctr + 1;
                rdy <= 1'b0;
            end else begin
                p <= stage3_accumulator;
                rdy <= 1'b1;
            end
            
            // Early termination for zero operands
            if (a == 8'b0 || b == 8'b0) begin
                p <= 16'b0;
                rdy <= 1'b1;
                stage_ctr <= 3'b100;
            end
        end
    end

endmodule