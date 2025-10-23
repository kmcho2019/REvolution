module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [4:0] ctr;
    reg prev_bit;  // Stores previous bit for Booth encoding

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 5'b0;
            rdy <= 1'b0;
            prev_bit <= 1'b0;
        end else begin
            if (ctr < 4) begin  // 4 steps for 8-bit radix-4 (8/2)
                // Examine 3 bits: {multiplier[1:0], prev_bit}
                case ({multiplier[1:0], prev_bit})
                    3'b000, 3'b111: begin
                        // No operation
                    end
                    3'b001, 3'b010: begin
                        p <= p + multiplicand;  // +A
                    end
                    3'b101, 3'b110: begin
                        p <= p - multiplicand;  // -A
                    end
                    3'b011: begin
                        p <= p + (multiplicand << 1);  // +2A
                    end
                    3'b100: begin
                        p <= p - (multiplicand << 1);  // -2A
                    end
                endcase
                
                // Update previous bit for next iteration
                prev_bit <= multiplier[1];
                
                // Radix-4 operation: shift multiplicand left by 2
                multiplicand <= multiplicand << 2;
                
                // Arithmetic right shift multiplier by 2 (preserves sign)
                multiplier <= $signed(multiplier) >>> 2;
                
                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                rdy <= 1'b1;  // Multiplication complete
            end
        end
    end

endmodule