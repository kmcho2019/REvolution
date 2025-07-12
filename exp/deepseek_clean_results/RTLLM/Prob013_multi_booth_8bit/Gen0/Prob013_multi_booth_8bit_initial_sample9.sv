module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;    // 16-bit multiplicand (sign-extended)
    reg [15:0] multiplier;      // 16-bit multiplier (sign-extended)
    reg [4:0] ctr;             // 5-bit counter (0-15)
    reg [1:0] prev_bit;        // Previous bit for Booth encoding

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 5'b0;
            prev_bit <= 2'b0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 8) begin  // Only need 4 iterations for 8 bits in Radix-4
                case (multiplier[1:0])
                    2'b00: ; // Do nothing
                    2'b01: p <= p + multiplicand;
                    2'b10: p <= p - multiplicand;
                    2'b11: ; // Do nothing (treated as 00 in next iteration)
                endcase

                // Arithmetic right shift of multiplier
                multiplier <= {multiplier[15], multiplier[15:1]};
                
                // Left shift multiplicand for next partial product
                multiplicand <= {multiplicand[14:0], 1'b0};
                
                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                rdy <= 1'b1;  // Multiplication complete
            end
        end
    end

endmodule