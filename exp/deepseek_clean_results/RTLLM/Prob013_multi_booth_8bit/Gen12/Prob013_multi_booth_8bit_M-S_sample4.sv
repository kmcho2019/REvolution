module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [16:0] mcand;    // 17-bit multiplicand (16 + guard bit)
    reg [8:0] mplier;    // 9-bit multiplier (8 + previous bit)
    reg [2:0] counter;   // 3-bit counter (0-3 for 4 iterations)
    reg prev_bit;        // Previous bit for Booth encoding

    always @(posedge clk) begin
        if (reset) begin
            mcand <= {9'b0, a};         // Initialize with 0 + multiplicand
            mplier <= {b, 1'b0};        // Initialize multiplier + 0 prev bit
            p <= 16'b0;
            counter <= 3'b0;
            rdy <= 1'b0;
            prev_bit <= 1'b0;
        end else if (!rdy) begin
            // Radix-4 Booth encoding
            case (mplier[1:0])
                2'b00: if (prev_bit) p <= p + (mcand << 1);  // +2
                2'b01: if (prev_bit) p <= p + mcand;          // +1
                2'b10: if (!prev_bit) p <= p - mcand;         // -1
                2'b11: if (!prev_bit) p <= p - (mcand << 1);  // -2
            endcase

            // Shift operations (Radix-4: shift by 2)
            mcand <= mcand << 2;
            mplier <= mplier >> 2;
            prev_bit <= mplier[1];
            
            counter <= counter + 1;
            rdy <= (counter == 3'd3);   // Done after 4 iterations
        end
    end

endmodule