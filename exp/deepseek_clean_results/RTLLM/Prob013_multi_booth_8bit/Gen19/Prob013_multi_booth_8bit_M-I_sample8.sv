module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Reduced register sizes
    reg [8:0] multiplicand;  // 8-bit + sign
    reg [2:0] multiplier;    // 2 current bits + prev_lsb
    reg [15:0] p_temp;
    reg [1:0] counter;
    reg stage1_valid, stage2_valid;
    
    // Clock gating signals
    wire clk_gated = clk & (~rdy | reset);
    
    // Booth encoding signals
    wire [2:0] booth_code;
    reg [15:0] stage1_operand;
    reg [15:0] stage2_result;
    
    assign booth_code = {multiplier[1:0], multiplier[2]};
    
    always @(posedge clk_gated) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {a[7], a};
            multiplier <= {b[1:0], 1'b0};  // Initialize with first 2 bits and prev_lsb=0
            p <= 16'b0;
            counter <= 2'b0;
            rdy <= 1'b0;
            stage1_valid <= 1'b0;
            stage2_valid <= 1'b0;
        end else begin
            // Pipeline Stage 1: Booth encoding and operand selection
            case (booth_code)
                3'b000, 3'b111: stage1_operand <= 16'b0;
                3'b001, 3'b010: stage1_operand <= {{7{multiplicand[8]}}, multiplicand};
                3'b011:         stage1_operand <= {{6{multiplicand[8]}}, multiplicand, 1'b0};
                3'b100:         stage1_operand <= -{{6{multiplicand[8]}}, multiplicand, 1'b0};
                3'b101, 3'b110: stage1_operand <= -{{7{multiplicand[8]}}, multiplicand};
            endcase
            stage1_valid <= (counter != 2'b11);
            
            // Pipeline Stage 2: Accumulation
            if (stage1_valid) begin
                stage2_result <= p + stage1_operand;
                stage2_valid <= 1'b1;
            end else begin
                stage2_valid <= 1'b0;
            end
            
            // Update registers for next iteration
            if (stage2_valid) begin
                p <= stage2_result;
                multiplicand <= multiplicand << 2;
                multiplier <= {b[2*counter+3:2*counter+2], multiplier[1]}; // Get next 2 bits
                
                if (counter == 2'b11) begin
                    rdy <= 1'b1;
                end else begin
                    counter <= counter + 1;
                end
            end
        end
    end

endmodule