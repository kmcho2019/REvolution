module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] mcand_ext;
    reg [7:0] mplier_stage1, mplier_stage2;
    reg [1:0] counter;
    reg [15:0] partial_prod1, partial_prod2;
    reg [15:0] accum_stage2, accum_stage3;
    reg early_term;
    
    // Booth encoding signals
    wire [1:0] booth_group1, booth_group2;
    wire [15:0] pp1, pp2;
    
    // Stage 1: Decode and early termination check
    always @(posedge clk) begin
        if (reset) begin
            mcand_ext <= {{8{a[7]}}, a};
            mplier_stage1 <= b;
            counter <= 0;
            early_term <= (b == 0);
            rdy <= 0;
            accum_stage2 <= 0;
        end else if (!rdy) begin
            // Early termination for special cases
            if (early_term || mplier_stage1 == 8'hFF || mplier_stage1 == 8'h01) begin
                rdy <= 1;
                p <= (mplier_stage1 == 8'hFF) ? -mcand_ext : 
                     (mplier_stage1 == 8'h01) ? mcand_ext : 0;
            end else begin
                // Normal pipeline operation
                mplier_stage1 <= mplier_stage1 >> 2;
                mplier_stage2 <= mplier_stage1;
                counter <= counter + 1;
                rdy <= (counter == 2'b11);
            end
        end
    end
    
    // Booth encoding for current and next group
    assign booth_group1 = {mplier_stage2[1:0], (counter == 0) ? 1'b0 : mplier_stage2[2]};
    assign booth_group2 = mplier_stage2[3:1];
    
    // Stage 2: Partial product generation
    always @(posedge clk) begin
        if (!reset && !rdy && !early_term) begin
            // Generate partial products in parallel
            case (booth_group1)
                3'b000, 3'b111: partial_prod1 <= 0;
                3'b001, 3'b010: partial_prod1 <= mcand_ext;
                3'b011:         partial_prod1 <= mcand_ext << 1;
                3'b100:         partial_prod1 <= -(mcand_ext << 1);
                3'b101, 3'b110: partial_prod1 <= -mcand_ext;
            endcase
            
            case (booth_group2)
                3'b000, 3'b111: partial_prod2 <= 0;
                3'b001, 3'b010: partial_prod2 <= mcand_ext << 2;
                3'b011:         partial_prod2 <= mcand_ext << 3;
                3'b100:         partial_prod2 <= -(mcand_ext << 3);
                3'b101, 3'b110: partial_prod2 <= -(mcand_ext << 2);
            endcase
            
            accum_stage2 <= accum_stage3;
        end
    end
    
    // Stage 3: Accumulation
    always @(posedge clk) begin
        if (!reset && !rdy && !early_term) begin
            accum_stage3 <= accum_stage2 + partial_prod1 + partial_prod2;
            if (counter == 2'b11) begin
                p <= accum_stage3;
            end
        end
    end
    
endmodule