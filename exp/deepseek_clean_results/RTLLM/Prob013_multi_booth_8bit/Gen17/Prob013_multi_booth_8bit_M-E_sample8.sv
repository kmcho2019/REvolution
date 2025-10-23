module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage1_multiplicand, stage2_multiplicand;
    reg [7:0] stage1_multiplier, stage2_multiplier;
    reg [1:0] stage1_booth_pair, stage2_booth_pair;
    reg stage1_prev_lsb, stage2_prev_lsb;
    reg [15:0] stage1_partial, stage2_partial;
    
    // Control signals
    reg [1:0] cycle_count;
    reg early_term;
    reg pipeline_valid;
    
    // Booth encoding results
    wire [15:0] booth_result;
    wire [15:0] next_booth_result;
    
    // Early termination detection
    wire all_zeros = (stage1_multiplier == 8'b0);
    wire all_ones = (stage1_multiplier == 8'hFF);
    wire termination_condition = all_zeros | all_ones;
    
    // Booth encoding logic (current pair)
    assign booth_result = 
        ({stage1_booth_pair, stage1_prev_lsb} == 3'b001 || 
         {stage1_booth_pair, stage1_prev_lsb} == 3'b010) ? stage1_partial + stage1_multiplicand :
        ({stage1_booth_pair, stage1_prev_lsb} == 3'b011) ? stage1_partial + (stage1_multiplicand << 1) :
        ({stage1_booth_pair, stage1_prev_lsb} == 3'b100) ? stage1_partial - (stage1_multiplicand << 1) :
        ({stage1_booth_pair, stage1_prev_lsb} == 3'b101 || 
         {stage1_booth_pair, stage1_prev_lsb} == 3'b110) ? stage1_partial - stage1_multiplicand :
        stage1_partial;
    
    // Next Booth pair pre-calculation
    assign next_booth_result = 
        ({stage1_multiplier[3:2], stage1_multiplier[1]} == 3'b001 || 
         {stage1_multiplier[3:2], stage1_multiplier[1]} == 3'b010) ? booth_result + (stage1_multiplicand << 2) :
        ({stage1_multiplier[3:2], stage1_multiplier[1]} == 3'b011) ? booth_result + (stage1_multiplicand << 3) :
        ({stage1_multiplier[3:2], stage1_multiplier[1]} == 3'b100) ? booth_result - (stage1_multiplicand << 3) :
        ({stage1_multiplier[3:2], stage1_multiplier[1]} == 3'b101 || 
         {stage1_multiplier[3:2], stage1_multiplier[1]} == 3'b110) ? booth_result - (stage1_multiplicand << 2) :
        booth_result;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers
            stage1_multiplicand <= 16'b0;
            stage2_multiplicand <= 16'b0;
            stage1_multiplier <= 8'b0;
            stage2_multiplier <= 8'b0;
            stage1_booth_pair <= 2'b0;
            stage2_booth_pair <= 2'b0;
            stage1_prev_lsb <= 1'b0;
            stage2_prev_lsb <= 1'b0;
            stage1_partial <= 16'b0;
            stage2_partial <= 16'b0;
            p <= 16'b0;
            rdy <= 1'b0;
            cycle_count <= 2'b0;
            early_term <= 1'b0;
            pipeline_valid <= 1'b0;
        end else begin
            if (!rdy) begin
                // Pipeline stage 1 (Booth encoding)
                if (!pipeline_valid) begin
                    // First cycle initialization
                    stage1_multiplicand <= {{8{a[7]}}, a};
                    stage1_multiplier <= b;
                    stage1_prev_lsb <= 1'b0;
                    stage1_partial <= 16'b0;
                    pipeline_valid <= 1'b1;
                    cycle_count <= 2'b0;
                end else begin
                    // Normal operation
                    stage1_booth_pair <= stage1_multiplier[1:0];
                    stage1_prev_lsb <= stage1_multiplier[1];
                    stage1_multiplier <= stage1_multiplier >> 2;
                    stage1_multiplicand <= stage1_multiplicand << 2;
                    
                    // Early termination detection
                    if (termination_condition && cycle_count != 0) begin
                        early_term <= 1'b1;
                        stage1_partial <= next_booth_result;
                    end else begin
                        stage1_partial <= booth_result;
                    end
                    
                    cycle_count <= cycle_count + 1;
                end
                
                // Pipeline stage 2 (Accumulation)
                stage2_multiplicand <= stage1_multiplicand;
                stage2_multiplier <= stage1_multiplier;
                stage2_booth_pair <= stage1_booth_pair;
                stage2_prev_lsb <= stage1_prev_lsb;
                stage2_partial <= stage1_partial;
                
                // Completion detection
                if (early_term || cycle_count == 2'b11) begin
                    p <= stage2_partial;
                    rdy <= 1'b1;
                    pipeline_valid <= 1'b0;
                    early_term <= 1'b0;
                end
            end else begin
                // Hold ready until new operation
                if (reset) rdy <= 1'b0;
            end
        end
    end

endmodule