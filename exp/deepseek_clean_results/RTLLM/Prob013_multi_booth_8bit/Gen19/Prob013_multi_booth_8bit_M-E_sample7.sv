module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage1_mcand;
    reg [8:0] stage1_mplier;  // Extra bit for sign extension
    reg [2:0] stage1_booth;
    reg [1:0] stage1_counter;
    
    reg [15:0] stage2_accum;
    reg [15:0] stage2_mcand;
    reg [1:0] stage2_counter;
    reg stage2_zero_flag;
    
    // Control signals
    wire [2:0] booth_code;
    wire zero_detect;
    wire [15:0] partial_product;
    
    // Booth encoding (combinational)
    assign booth_code = {stage1_mplier[1:0], stage1_mplier[2]};
    
    // Zero detection
    assign zero_detect = (stage1_mplier[7:0] == 8'b0);
    
    // Partial product generation
    assign partial_product = 
        (booth_code == 3'b000 || booth_code == 3'b111) ? 16'b0 :
        (booth_code == 3'b001 || booth_code == 3'b010) ? stage1_mcand :
        (booth_code == 3'b011) ? (stage1_mcand << 1) :
        (booth_code == 3'b100) ? -(stage1_mcand << 1) :
        -(stage1_mcand);
    
    // Pipeline stage 1 (Booth encoding)
    always @(posedge clk) begin
        if (reset) begin
            stage1_mcand <= {{8{a[7]}}, a};
            stage1_mplier <= {b, 1'b0};
            stage1_counter <= 2'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            // Shift multiplier right by 2
            stage1_mplier <= {2'b0, stage1_mplier[8:2]};
            
            // Store booth code for next stage
            stage1_booth <= booth_code;
            
            // Shift multiplicand left by 2 for next iteration
            stage1_mcand <= stage1_mcand << 2;
            
            // Update counter
            stage1_counter <= stage1_counter + 1;
            
            // Pass zero detection to stage 2
            stage2_zero_flag <= zero_detect;
        end
    end
    
    // Pipeline stage 2 (Accumulation)
    always @(posedge clk) begin
        if (reset) begin
            stage2_accum <= 16'b0;
            stage2_mcand <= 16'b0;
            stage2_counter <= 2'b0;
        end else if (!rdy) begin
            // Accumulate partial product
            stage2_accum <= stage2_accum + partial_product;
            
            // Update completion status
            if (stage2_zero_flag || stage2_counter == 2'b11) begin
                rdy <= 1'b1;
                p <= stage2_accum;
            end
            
            stage2_counter <= stage1_counter;
        end
    end

endmodule