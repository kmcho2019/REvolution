module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [9:0] mcand;         // Optimized width (8 + 2 bits for shifting)
    reg [7:0] mplier;        // Multiplier (right shifted)
    reg [1:0] counter;       // 2-bit counter for 4 iterations
    reg prev_bit;            // Previous bit for Booth encoding
    wire [9:0] mcand_x2;     // Pre-computed x2 value
    wire zero_operand;       // Early zero detection
    
    // Pre-compute shifted values and zero detection
    assign mcand_x2 = {mcand[7:0], 2'b0}; // Equivalent to << 2
    assign zero_operand = (a == 8'b0) | (b == 8'b0);
    
    always @(posedge clk) begin
        if (reset) begin
            // Initialize with sign extension
            mcand <= {{2{a[7]}}, a};
            mplier <= b;
            p <= 16'b0;
            counter <= 2'b0;
            prev_bit <= 1'b0;
            rdy <= zero_operand;  // Early completion for zero inputs
        end
        else if (!rdy) begin
            // Booth encoding and product update
            case ({mplier[1:0], prev_bit})
                3'b001, 3'b010: p <= p + {{6{mcand[9]}}, mcand}; // +1
                3'b011:         p <= p + {{6{mcand_x2[9]}}, mcand_x2}; // +2
                3'b100:         p <= p - {{6{mcand_x2[9]}}, mcand_x2}; // -2
                3'b101, 3'b110: p <= p - {{6{mcand[9]}}, mcand}; // -1
                default:        p <= p; // +0 (000,111)
            endcase
            
            // Update registers for next iteration
            mcand <= mcand_x2;
            mplier <= mplier >> 2;
            prev_bit <= mplier[1];
            counter <= counter + 1;
            
            // Completion detection
            rdy <= (counter == 2'b11) | zero_operand;
        end
    end

endmodule