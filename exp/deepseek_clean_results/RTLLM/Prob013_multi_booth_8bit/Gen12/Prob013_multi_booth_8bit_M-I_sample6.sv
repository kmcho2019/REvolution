module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Optimized register widths
    reg [9:0] mcand;     // Multiplicand (8 + 2 bits for shift)
    reg [7:0] mplier;    // Multiplier
    reg [1:0] counter;   // 2-bit counter
    reg prev_bit;        // Previous bit for Booth encoding
    
    // Pipeline registers
    reg [15:0] p_next;
    reg [1:0] booth_sel;
    reg compute_en;
    
    // Pre-computed values
    wire [15:0] mcand_x1 = {{6{mcand[9]}}, mcand};
    wire [15:0] mcand_x2 = {{5{mcand[9]}}, mcand, 1'b0};

    always @(posedge clk) begin
        if (reset) begin
            mcand <= {a, 2'b0};          // Sign extend + 2-bit shift buffer
            mplier <= b;
            p <= 16'b0;
            counter <= 2'b0;
            prev_bit <= 1'b0;
            rdy <= 1'b0;
            compute_en <= 1'b0;
        end else begin
            // Stage 1: Booth encoding and pre-computation
            if (!rdy) begin
                case ({mplier[1:0], prev_bit})
                    3'b000, 3'b111: booth_sel <= 2'b00;  // +0
                    3'b001, 3'b010: booth_sel <= 2'b01;  // +1
                    3'b011:         booth_sel <= 2'b10;  // +2
                    3'b100:         booth_sel <= 2'b11;  // -2
                    3'b101, 3'b110: booth_sel <= 2'b01;  // -1 (will negate)
                endcase
                compute_en <= 1'b1;
            end else begin
                compute_en <= 1'b0;
            end

            // Stage 2: Arithmetic operation
            if (compute_en) begin
                case (booth_sel)
                    2'b00: p_next <= p;
                    2'b01: p_next <= ({mplier[1:0], prev_bit}[2] ? p - mcand_x1 : p + mcand_x1);
                    2'b10: p_next <= p + mcand_x2;
                    2'b11: p_next <= p - mcand_x2;
                endcase
                
                // Update registers for next cycle
                mcand <= mcand << 2;     // Gated by compute_en in practice
                mplier <= mplier >> 2;
                prev_bit <= mplier[1];
                counter <= counter + 1;
                rdy <= (counter == 2'b11);
                p <= p_next;
            end
        end
    end

endmodule