module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage1_pp_high, stage1_pp_low;
    reg [15:0] stage2_result;
    reg stage1_valid, stage2_valid;
    
    // Shared Booth encoder
    wire [2:0] booth_high = {b[7:6], (|b[5:0])};
    wire [2:0] booth_low = {b[3:2], (|b[1:0])};
    
    // Partial product generators
    wire [15:0] pp_high, pp_low;
    
    // High nibble processing (bits 7:4)
    assign pp_high = 
        (booth_high == 3'b000 || booth_high == 3'b111) ? 16'b0 :
        (booth_high == 3'b001 || booth_high == 3'b010) ? {{8{a[7]}}, a} :
        (booth_high == 3'b011) ? {{7{a[7]}}, a, 1'b0} :
        (booth_high == 3'b100) ? -{{7{a[7]}}, a, 1'b0} :
        -{{8{a[7]}}, a};
    
    // Low nibble processing (bits 3:0)
    assign pp_low = 
        (booth_low == 3'b000 || booth_low == 3'b111) ? 16'b0 :
        (booth_low == 3'b001 || booth_low == 3'b010) ? {{8{a[7]}}, a} :
        (booth_low == 3'b011) ? {{7{a[7]}}, a, 1'b0} :
        (booth_low == 3'b100) ? -{{7{a[7]}}, a, 1'b0} :
        -{{8{a[7]}}, a};

    always @(posedge clk) begin
        if (reset) begin
            // Pipeline flush
            stage1_pp_high <= 16'b0;
            stage1_pp_low <= 16'b0;
            stage1_valid <= 1'b0;
            stage2_result <= 16'b0;
            stage2_valid <= 1'b0;
            p <= 16'b0;
            rdy <= 1'b0;
        end else begin
            // Stage 1: Parallel partial product generation
            stage1_pp_high <= pp_high << 4;
            stage1_pp_low <= pp_low;
            stage1_valid <= 1'b1;
            
            // Stage 2: Weighted accumulation
            stage2_result <= stage1_pp_high + stage1_pp_low;
            stage2_valid <= stage1_valid;
            
            // Output stage
            p <= stage2_result;
            rdy <= stage2_valid;
        end
    end

endmodule