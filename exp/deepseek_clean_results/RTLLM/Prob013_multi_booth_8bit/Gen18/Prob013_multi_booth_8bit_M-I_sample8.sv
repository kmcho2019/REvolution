module multi_booth_8bit (
    input clk,
    input reset,
    input signed [7:0] a,
    input signed [7:0] b,
    output reg signed [15:0] p,
    output reg rdy
);

    reg signed [15:0] mcand;         // Sign-extended multiplicand
    reg [7:0] mplier;               // Multiplier (right-shifted)
    reg [1:0] counter;              // 2-bit counter (0-3)
    reg prev_bit;                   // Previous LSB for Booth encoding
    
    // Pipeline registers
    reg signed [15:0] pp_accum;     // Partial product accumulator
    reg signed [15:0] mcand_x1;     // Stage 1: x1 value
    reg signed [15:0] mcand_x2;     // Stage 1: x2 value
    reg [2:0] booth_sel;            // Stage 1: Booth selection
    
    // Control signals
    wire active_cycle = ~reset & ~rdy;
    wire zero_operand = (a == 0) | (b == 0);
    
    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers
            mcand <= a;
            mplier <= b;
            pp_accum <= 0;
            counter <= 0;
            prev_bit <= 0;
            rdy <= zero_operand;
            
            // Clear pipeline registers
            mcand_x1 <= 0;
            mcand_x2 <= 0;
            booth_sel <= 0;
        end
        else if (active_cycle) begin
            // Stage 0: Pre-compute shifted values
            mcand_x1 <= mcand;
            mcand_x2 <= mcand << 1;
            booth_sel <= {mplier[1:0], prev_bit};
            
            // Stage 1: Booth encoding selection
            case (booth_sel)
                3'b001, 3'b010: pp_accum <= pp_accum + mcand_x1;    // +1
                3'b011:         pp_accum <= pp_accum + mcand_x2;    // +2
                3'b100:         pp_accum <= pp_accum - mcand_x2;     // -2
                3'b101, 3'b110: pp_accum <= pp_accum - mcand_x1;    // -1
                default:        pp_accum <= pp_accum;               // +0
            endcase
            
            // Stage 2: Update registers and shift
            mcand <= mcand << 2;
            mplier <= mplier >> 2;
            prev_bit <= mplier[1];
            counter <= counter + 1;
            
            // Final product assignment
            p <= pp_accum;
            
            // Completion detection
            rdy <= (counter == 2'b11) | zero_operand;
        end
    end

endmodule