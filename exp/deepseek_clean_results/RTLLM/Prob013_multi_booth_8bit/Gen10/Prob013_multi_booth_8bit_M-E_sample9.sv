module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline Stage 1 Registers
    reg [15:0] mcand_ext;
    reg [8:0] mplier_ext;  // Extra bit for sign extension
    reg [1:0] stage1_ctr;
    reg stage1_active;
    
    // Pipeline Stage 2 Registers
    reg [15:0] partial_sum;
    reg [15:0] partial_carry;
    reg [1:0] stage2_ctr;
    reg stage2_active;
    
    // Pipeline Stage 3 Registers
    reg [15:0] final_sum;
    reg stage3_active;

    // Booth encoding signals
    wire [2:0] booth_bits;
    reg [15:0] pp_select;
    reg pp_sign;

    // Early termination detection
    wire early_term = (a == 0) || (b == 0);

    // Stage 1: Booth Encoding and Partial Product Selection
    always @(posedge clk) begin
        if (reset) begin
            mcand_ext <= {{8{a[7]}}, a};
            mplier_ext <= {b, 1'b0};  // Add LSB 0 for initial Booth pair
            stage1_ctr <= 0;
            stage1_active <= ~early_term;
            rdy <= early_term;
            p <= 0;
        end else if (!rdy) begin
            if (stage1_active) begin
                // Booth encoding
                case (mplier_ext[2:0])
                    3'b000, 3'b111: pp_select <= 0;
                    3'b001, 3'b010: pp_select <= mcand_ext;
                    3'b011: pp_select <= mcand_ext << 1;
                    3'b100: pp_select <= mcand_ext << 1;
                    3'b101, 3'b110: pp_select <= mcand_ext;
                endcase
                
                pp_sign <= |mplier_ext[2:0] & mplier_ext[2];
                
                // Update for next cycle
                mcand_ext <= mcand_ext << 2;
                mplier_ext <= mplier_ext >> 2;
                stage1_ctr <= stage1_ctr + 1;
                
                // Pass to stage 2
                stage2_active <= 1;
            end else begin
                stage2_active <= 0;
            end
            
            // Early termination check
            if (early_term) begin
                rdy <= 1;
                p <= 0;
            end
        end
    end

    // Stage 2: Carry-Save Accumulation
    always @(posedge clk) begin
        if (reset) begin
            partial_sum <= 0;
            partial_carry <= 0;
            stage2_ctr <= 0;
            stage3_active <= 0;
        end else if (stage2_active) begin
            // Carry-save addition
            {partial_carry, partial_sum} <= 
                {1'b0, partial_sum} + 
                {1'b0, pp_sign ? ~pp_select + 1 : pp_select} + 
                {partial_carry, 1'b0};
                
            stage2_ctr <= stage1_ctr;
            stage3_active <= (stage1_ctr == 3);
        end else begin
            stage3_active <= 0;
        end
    end

    // Stage 3: Final Addition and Output
    always @(posedge clk) begin
        if (reset) begin
            final_sum <= 0;
            rdy <= 0;
            p <= 0;
        end else if (stage3_active) begin
            // Final carry-propagate addition
            final_sum <= partial_sum + (partial_carry << 1);
            rdy <= 1;
            p <= final_sum;
        end
    end

endmodule