module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] mcand;        // Sign-extended multiplicand
    reg [7:0] mplier;        // Multiplier (right-shifted)
    reg [1:0] counter;       // 2-bit counter (0-3)
    reg prev_bit;            // Previous LSB for Booth encoding
    wire [15:0] mcand_x2;    // Pre-computed x2 value
    
    // Clock gating control
    wire active_cycle = ~reset & ~rdy;
    
    // Pre-compute shifted values
    assign mcand_x2 = mcand << 1;
    
    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers
            mcand <= {{8{a[7]}}, a};
            mplier <= b;
            p <= 16'b0;
            counter <= 2'b0;
            prev_bit <= 1'b0;
            rdy <= (a == 8'b0) | (b == 8'b0); // Early termination for zero
        end
        else if (active_cycle) begin
            // Booth encoding and product update
            case ({mplier[1:0], prev_bit})
                3'b001, 3'b010: p <= p + mcand;      // +1
                3'b011:         p <= p + mcand_x2;   // +2
                3'b100:         p <= p - mcand_x2;    // -2
                3'b101, 3'b110: p <= p - mcand;      // -1
                default:        p <= p;              // +0 (000,111)
            endcase
            
            // Update registers
            mcand <= mcand << 2;
            mplier <= mplier >> 2;
            prev_bit <= mplier[1];
            counter <= counter + 1;
            
            // Completion detection
            rdy <= (counter == 2'b11);
        end
    end

endmodule