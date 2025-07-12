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
    reg [15:0] next_p;       // Next product value

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers
            mcand <= {{8{a[7]}}, a};
            mplier_bits <= {b[1:0], 1'b0};
            p <= 16'b0;
            counter <= 2'b0;
            rdy <= 1'b0;
        end
        else if (!rdy) begin
            // Booth encoding
            case (mplier_bits)
                3'b001, 3'b010: next_p = p + mcand;      // +1
                3'b011:         next_p = p + (mcand << 1); // +2
                3'b100:         next_p = p - (mcand << 1); // -2
                3'b101, 3'b110: next_p = p - mcand;      // -1
                default:       next_p = p;              // +0 (000,111)
            endcase

            // Update registers
            p <= next_p;
            mcand <= mcand << 2;
            mplier_bits <= b[counter*2+2 -: 3];  // Get next 3 bits
            counter <= counter + 1;

            // Completion after 4 cycles
            if (counter == 2'b11) rdy <= 1'b1;
        end
    end

endmodule