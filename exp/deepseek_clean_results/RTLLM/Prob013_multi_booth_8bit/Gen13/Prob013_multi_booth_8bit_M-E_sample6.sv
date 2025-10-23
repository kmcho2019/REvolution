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
    reg [15:0] stage1_pp;
    reg [2:0] stage1_booth;
    reg [3:0] stage1_ctr;
    
    reg [15:0] stage2_acc;
    reg [3:0] stage2_ctr;
    reg stage2_active;
    
    // Early termination detection
    wire all_zeros = (stage1_ctr > 4'd3) && (b[2*stage1_ctr+1 -:2] == 2'b00);
    wire all_ones = (stage1_ctr > 4'd3) && (b[2*stage1_ctr+1 -:2] == 2'b11);
    wire early_term = all_zeros || all_ones;
    
    // Clock gating control
    wire clk_en = !rdy && !(early_term && stage2_ctr == stage1_ctr);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Stage1 initialization
            stage1_mcand <= {{8{a[7]}}, a};
            stage1_pp <= 16'b0;
            stage1_booth <= 3'b0;
            stage1_ctr <= 4'b0;
            
            // Stage2 initialization
            stage2_acc <= 16'b0;
            stage2_ctr <= 4'b0;
            stage2_active <= 1'b0;
            
            // Outputs
            p <= 16'b0;
            rdy <= 1'b0;
        end else if (clk_en) begin
            // Pipeline Stage1: Booth encoding and partial product generation
            case (b[2*stage1_ctr+1 -:3])  // Examine 3 bits (current+previous)
                3'b000, 3'b111: stage1_pp <= 16'b0;
                3'b001, 3'b010: stage1_pp <= stage1_mcand;
                3'b011: stage1_pp <= stage1_mcand << 1;
                3'b100: stage1_pp <= -(stage1_mcand << 1);
                3'b101, 3'b110: stage1_pp <= -stage1_mcand;
            endcase
            stage1_booth <= b[2*stage1_ctr+1 -:3];
            stage1_mcand <= stage1_mcand << 2;
            stage1_ctr <= stage1_ctr + 1;
            
            // Pipeline Stage2: Accumulation
            if (stage2_active) begin
                // Carry-save addition
                stage2_acc <= stage2_acc + stage1_pp;
                stage2_ctr <= stage2_ctr + 1;
            end
            stage2_active <= (stage1_ctr > 0);
            
            // Completion detection
            if (stage2_ctr == 4'd3 && stage1_ctr == 4'd4) begin
                p <= stage2_acc;
                rdy <= 1'b1;
            end
        end
    end

endmodule