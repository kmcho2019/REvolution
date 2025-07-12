module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage1_multiplicand;
    reg [8:0] stage1_multiplier;
    reg [3:0] stage1_counter;
    reg stage1_active;
    
    // Booth encoding
    wire [1:0] booth_bits = stage1_multiplier[1:0];
    wire [1:0] booth_sel;
    
    // Partial products
    wire [15:0] pp_x1 = stage1_multiplicand;
    wire [15:0] pp_x2 = {stage1_multiplicand[14:0], 1'b0};
    wire [15:0] pp_neg_x1 = ~stage1_multiplicand + 1;
    wire [15:0] pp_neg_x2 = ~{stage1_multiplicand[14:0], 1'b0} + 1;
    
    // Early termination detection
    wire remaining_bits_zero = (stage1_multiplier[8:2] == 7'b0);
    wire remaining_bits_ones = (stage1_multiplier[8:2] == 7'b1111111);
    wire early_term = remaining_bits_zero | remaining_bits_ones;
    
    // Booth encoder
    assign booth_sel = (booth_bits == 2'b00 || booth_bits == 2'b11) ? 2'b00 :
                      (booth_bits == 2'b01) ? 2'b01 :
                      (booth_bits == 2'b10) ? 2'b10 : 2'b00;
    
    // Partial product selection
    wire [15:0] partial_product = 
        (booth_sel == 2'b00) ? 16'b0 :
        (booth_sel == 2'b01) ? pp_x1 :
        (booth_sel == 2'b10) ? pp_neg_x1 : pp_x2;
    
    // Accumulation stage
    always @(posedge clk) begin
        if (reset) begin
            // Initialize pipeline
            stage1_multiplicand <= {{8{a[7]}}, a};
            stage1_multiplier <= {b, 1'b0};
            stage1_counter <= 4'b0;
            stage1_active <= 1'b1;
            p <= 16'b0;
            rdy <= 1'b0;
        end else begin
            // Pipeline stage 1 to stage 2
            if (stage1_active) begin
                // Accumulate partial product
                p <= p + partial_product;
                
                // Shift operations
                stage1_multiplicand <= stage1_multiplicand << 2;
                stage1_multiplier <= {2'b0, stage1_multiplier[8:2]};
                
                // Update counter and termination
                stage1_counter <= stage1_counter + 1;
                
                // Check completion conditions
                if (early_term || stage1_counter == 4'b0011) begin
                    stage1_active <= 1'b0;
                    rdy <= 1'b1;
                end
            end
        end
    end

endmodule