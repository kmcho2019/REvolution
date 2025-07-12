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
    reg [1:0] prev_bit;  // Stores previous bit for Booth encoding

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 5'b0;
            rdy <= 1'b0;
            prev_bit <= 2'b0;
        end else begin
            if (ctr < 4) begin  // 4 steps for 8-bit radix-4
                case (multiplier[1:0])
                    2'b00: begin
                        // No operation
                    end
                    2'b01: begin
                        p <= p + multiplicand;
                    end
                    2'b10: begin
                        p <= p - multiplicand;
                    end
                    2'b11: begin
                        // No operation (treated as 00 in next step)
                    end
                endcase
                
                // Radix-4 operation: shift multiplicand left by 2
                multiplicand <= multiplicand << 2;
                
                // Shift multiplier right by 2 (arithmetic shift for sign extension)
                multiplier <= { {2{multiplier[15]}}, multiplier[15:2] };
                
                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                rdy <= 1'b1;  // Multiplication complete
            end
        end
    end

endmodule