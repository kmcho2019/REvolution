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
reg [1:0] prev_bit;  // For tracking previous bits in Booth encoding

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
        if (ctr < 8) begin  // 8 steps for 8-bit Radix-4
            case (multiplier[1:0])
                2'b00: begin  // No operation
                    p <= p;
                end
                2'b01: begin  // Add multiplicand
                    p <= p + multiplicand;
                end
                2'b10: begin  // Subtract multiplicand
                    p <= p - multiplicand;
                end
                2'b11: begin  // No operation (treated as 00 in next step)
                    p <= p;
                end
            endcase

            // Shift multiplicand left by 2 (Radix-4)
            multiplicand <= multiplicand << 2;
            
            // Arithmetic right shift multiplier by 2 (preserve sign)
            multiplier <= { {2{multiplier[15]}}, multiplier[15:2] };
            
            ctr <= ctr + 1;
            rdy <= 1'b0;
        end else begin
            rdy <= 1'b1;  // Multiplication complete
        end
    end
end

endmodule