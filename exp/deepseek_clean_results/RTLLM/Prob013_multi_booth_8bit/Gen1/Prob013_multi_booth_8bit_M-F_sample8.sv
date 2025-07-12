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
    reg [2:0] ctr;  // Only need 3 bits (0-4)
    reg prev_bit;   // Previous bit for Booth encoding

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 3'b0;
            rdy <= 1'b0;
            prev_bit <= 1'b0;
        end else begin
            if (ctr < 4) begin
                case ({multiplier[1:0], prev_bit})
                    3'b000, 3'b111: begin
                        // No operation
                        p <= p;
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
                
                // Arithmetic right shift multiplier by 2
                multiplier <= {{2{multiplier[15]}}, multiplier[15:2]};
                // Left shift multiplicand by 2
                multiplicand <= multiplicand << 2;
                // Update previous bit
                prev_bit <= multiplier[1];
                
                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                // Multiplication complete after 4 cycles
                rdy <= 1'b1;
            end
        end
    end

endmodule