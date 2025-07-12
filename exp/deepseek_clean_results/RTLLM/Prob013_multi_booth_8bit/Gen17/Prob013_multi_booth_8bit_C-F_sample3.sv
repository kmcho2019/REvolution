module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] mcand;        // Sign-extended multiplicand
    reg [2:0] mplier_bits;   // Current multiplier bits (2 bits + prev)
    reg [1:0] counter;       // 2-bit counter (0-3)
    wire [15:0] mcand_x2;    // Pre-computed x2 value
    wire zero_operand;       // Early zero detection
    
    // Pre-compute shifted values and zero detection
    assign mcand_x2 = mcand << 1;
    assign zero_operand = (a == 8'b0) | (b == 8'b0);
    
    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers with reset values
            mcand <= {{8{a[7]}}, a};
            mplier_bits <= {b[1:0], 1'b0};
            p <= 16'b0;
            counter <= 2'b0;
            rdy <= zero_operand;  // Early completion for zero inputs
            
            // Pre-load multiplier shift register
            if (!zero_operand) begin
                mplier_bits[2] <= b[1];  // Save next bit for next iteration
            end
        end
        else if (!rdy) begin
            // Booth encoding and product update
            case (mplier_bits)
                3'b001, 3'b010: p <= p + mcand;      // +1
                3'b011:         p <= p + mcand_x2;   // +2
                3'b100:         p <= p - mcand_x2;   // -2
                3'b101, 3'b110: p <= p - mcand;      // -1
                default:        p <= p;              // +0 (000,111)
            endcase
            
            // Update registers for next iteration
            mcand <= mcand << 2;
            mplier_bits <= {b[counter*2+3], b[counter*2+2], b[counter*2+1]};
            counter <= counter + 1;
            
            // Completion detection
            if (counter == 2'b11) begin
                rdy <= 1'b1;
            end
        end
    end

endmodule