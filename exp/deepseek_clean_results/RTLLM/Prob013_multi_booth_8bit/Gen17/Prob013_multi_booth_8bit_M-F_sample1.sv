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
    reg [3:0] ctr;
    reg prev_bit;

    // Booth encoding function
    function [15:0] booth_encode;
        input [2:0] bits;
        input [15:0] mcand;
        begin
            case (bits)
                3'b000, 3'b111: booth_encode = 16'b0;
                3'b001, 3'b010: booth_encode = mcand;
                3'b011: booth_encode = mcand << 1;
                3'b100: booth_encode = -(mcand << 1);
                default: booth_encode = -mcand; // 101,110
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize with sign-extended inputs
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 4'b0;
            prev_bit <= 1'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 4) begin
                // Get current 2 bits + previous bit
                reg [2:0] booth_bits;
                booth_bits = {multiplier[1:0], prev_bit};
                
                // Calculate and accumulate partial product
                p <= p + booth_encode(booth_bits, multiplicand);
                
                // Arithmetic right shift multiplier by 2
                multiplier <= { {2{multiplier[15]}}, multiplier[15:2] };
                
                // Update previous bit and counter
                prev_bit <= multiplier[1];
                ctr <= ctr + 1;
                
                // Left shift multiplicand by 2 for next iteration
                multiplicand <= multiplicand << 2;
            end else begin
                // Multiplication complete
                rdy <= 1'b1;
            end
        end
    end

endmodule