module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [9:0] mcand;      // Multiplicand (8-bit + 2-bit shift headroom)
    reg [8:0] mplier;     // Multiplier (8-bit + previous bit)
    reg [1:0] counter;    // 2-bit counter for 4 iterations
    reg [15:0] arith_temp;// Shared arithmetic unit

    always @(posedge clk) begin
        if (reset) begin
            mcand <= a;                       // Will be sign extended in operation
            mplier <= {b, 1'b0};              // Initialize with multiplier + prev_bit=0
            p <= 16'b0;
            counter <= 2'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            // Booth Radix-4 encoding
            case (mplier[2:0])
                3'b001, 3'b010: arith_temp = p + { {6{mcand[9]}}, mcand };  // +1
                3'b011:         arith_temp = p + { {5{mcand[9]}}, mcand, 1'b0 }; // +2
                3'b100:         arith_temp = p - { {5{mcand[9]}}, mcand, 1'b0 }; // -2
                3'b101, 3'b110: arith_temp = p - { {6{mcand[9]}}, mcand };  // -1
                default:        arith_temp = p;                              // 0
            endcase

            // Update registers
            p <= arith_temp;
            mcand <= {mcand[7:0], 2'b0};      // Shift left by 2
            mplier <= {2'b0, mplier[8:2]};    // Shift right by 2
            counter <= counter + 1;
            rdy <= (counter == 2'b11);       // Complete after 4 iterations
        end
    end

endmodule