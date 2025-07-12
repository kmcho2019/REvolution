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
    reg [7:0] stage1_mplier;
    reg [1:0] stage1_counter;
    reg stage1_prev_bit;
    
    // Partial products
    reg [15:0] pp0, pp1, pp2, pp3;
    reg [15:0] sum, carry;
    
    // Control signals
    reg stage1_valid, stage2_valid;
    wire stage1_ready, stage2_ready;
    
    assign stage1_ready = !stage1_valid || stage2_ready;
    assign stage2_ready = !stage2_valid || rdy;
    
    // Stage 1: Booth encoding and partial product generation
    always @(posedge clk) begin
        if (reset) begin
            stage1_mcand <= {{8{a[7]}}, a};
            stage1_mplier <= b;
            stage1_counter <= 2'b0;
            stage1_prev_bit <= 1'b0;
            stage1_valid <= 1'b0;
            rdy <= 1'b0;
        end else if (stage1_ready) begin
            if (!rdy) begin
                // Generate all 4 possible partial products in parallel
                case ({stage1_mplier[1:0], stage1_prev_bit})
                    3'b000, 3'b111: pp0 <= 16'b0;
                    3'b001, 3'b010: pp0 <= stage1_mcand;
                    3'b011: pp0 <= stage1_mcand << 1;
                    3'b100: pp0 <= -(stage1_mcand << 1);
                    3'b101, 3'b110: pp0 <= -stage1_mcand;
                endcase
                
                pp1 <= stage1_mcand << 2;
                pp2 <= stage1_mcand << 4;
                pp3 <= stage1_mcand << 6;
                
                stage1_mcand <= stage1_mcand << 2;
                stage1_mplier <= stage1_mplier >> 2;
                stage1_prev_bit <= stage1_mplier[1];
                stage1_counter <= stage1_counter + 1;
                stage1_valid <= 1'b1;
                rdy <= (stage1_counter == 2'b11);
            end else begin
                stage1_valid <= 1'b0;
            end
        end
    end
    
    // Stage 2: Carry-save accumulation
    always @(posedge clk) begin
        if (reset) begin
            sum <= 16'b0;
            carry <= 16'b0;
            p <= 16'b0;
            stage2_valid <= 1'b0;
        end else if (stage2_ready) begin
            if (stage1_valid) begin
                // Carry-save addition of partial products
                {carry, sum} <= pp0 + pp1 + pp2 + pp3;
                stage2_valid <= 1'b1;
            end else if (stage2_valid) begin
                // Final addition
                p <= sum + (carry << 1);
                stage2_valid <= 1'b0;
            end
        end
    end

endmodule