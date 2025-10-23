module multi_booth_8bit (
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
reg [1:0] prev_bits;       // Previous bits for Booth encoding

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize on reset
        multiplicand <= {{8{a[7]}}, a};
        multiplier <= {{8{b[7]}}, b};
        p <= 16'b0;
        ctr <= 5'b0;
        prev_bits <= 2'b0;
        rdy <= 1'b0;
    end else begin
        if (ctr < 8) begin  // Only need 4 iterations for 8 bits in Radix-4
            rdy <= 1'b0;
            
            // Booth encoding - examine 3 bits (current and previous)
            case ({multiplier[1:0], prev_bits[0]})
                3'b000, 3'b111: begin
                    // No operation
                end
                3'b001, 3'b010: begin
                    // Add multiplicand
                    p <= p + multiplicand;
                end
                3'b011: begin
                    // Add 2*multiplicand
                    p <= p + (multiplicand << 1);
                end
                3'b100: begin
                    // Subtract 2*multiplicand
                    p <= p - (multiplicand << 1);
                end
                3'b101, 3'b110: begin
                    // Subtract multiplicand
                    p <= p - multiplicand;
                end
            endcase
            
            // Arithmetic right shift of multiplier (preserves sign)
            multiplier <= {multiplier[15], multiplier[15:1]};
            prev_bits <= multiplier[1:0];
            
            // Left shift multiplicand for next partial product
            multiplicand <= multiplicand << 2;
            
            ctr <= ctr + 1;
        end else begin
            // Multiplication complete
            rdy <= 1'b1;
        end
    end
end

endmodule