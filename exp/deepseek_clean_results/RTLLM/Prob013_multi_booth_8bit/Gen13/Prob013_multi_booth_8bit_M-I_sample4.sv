module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] mcand;        // Multiplicand (sign extended)
    reg [15:0] mplier;       // Multiplier (sign extended)
    reg [4:0] counter;       // 5-bit counter as specified
    reg prev_bit;            // Previous bit for Booth encoding
    
    // Pipeline registers
    reg [15:0] p_next;
    reg [1:0] booth_sel;
    reg compute_en;
    
    // Pre-computed values
    wire [15:0] mcand_x1 = mcand;
    wire [15:0] mcand_x2 = {mcand[14:0], 1'b0};  // x2 (left shift 1)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mcand <= {{8{a[7]}}, a};     // Sign extend multiplicand
            mplier <= {{8{b[7]}}, b};    // Sign extend multiplier
            p <= 16'b0;
            counter <= 5'b0;
            prev_bit <= 1'b0;
            rdy <= 1'b0;
            compute_en <= 1'b0;
        end else begin
            // Stage 1: Booth encoding
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
                    2'b01: begin
                        if ({mplier[1:0], prev_bit}[2]) 
                            p_next <= p - mcand_x1;
                        else 
                            p_next <= p + mcand_x1;
                    end
                    2'b10: p_next <= p + mcand_x2;
                    2'b11: p_next <= p - mcand_x2;
                endcase
                
                // Update registers for next cycle
                mcand <= mcand << 2;     // Radix-4 shift
                mplier <= mplier >> 2;    // Radix-4 shift
                prev_bit <= mplier[1];
                counter <= counter + 1;
                rdy <= (counter == 5'b1000); // 8-bit needs 4 Radix-4 steps
                p <= p_next;
            end
        end
    end

endmodule