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
    reg [2:0] ctr;  // Reduced to 3-bit counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 3'b0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 8) begin  // 8 steps for 8-bit multiplication
                case (multiplier[1:0])
                    2'b01: p <= p + multiplicand;  // +A
                    2'b10: p <= p - multiplicand;  // -A
                    default: ;  // No operation for 00 or 11
                endcase
                
                // Shift multiplicand left by 1
                multiplicand <= multiplicand << 1;
                
                // Arithmetic right shift multiplier by 1
                multiplier <= $signed(multiplier) >>> 1;
                
                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                rdy <= 1'b1;  // Multiplication complete
            end
        end
    end

endmodule