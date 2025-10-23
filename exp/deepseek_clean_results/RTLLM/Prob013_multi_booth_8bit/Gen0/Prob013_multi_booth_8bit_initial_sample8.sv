module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;  // 16-bit multiplicand (sign extended)
reg [15:0] multiplier;    // 16-bit multiplier (sign extended)
reg [4:0] ctr;           // 5-bit counter (0-15)
reg [15:0] product;       // 16-bit product register

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize registers on reset
        multiplicand <= {{8{a[7]}}, a};  // Sign-extend a to 16 bits
        multiplier <= {{8{b[7]}}, b};    // Sign-extend b to 16 bits
        product <= 16'b0;
        ctr <= 5'b0;
        rdy <= 1'b0;
    end
    else if (!rdy) begin
        if (ctr < 8) begin
            // Booth Radix-4 encoding
            case (multiplier[1:0])
                2'b00, 2'b11: 
                    product <= product;  // No operation
                2'b01: 
                    product <= product + multiplicand;  // Add multiplicand
                2'b10: 
                    product <= product - multiplicand;  // Subtract multiplicand
            endcase

            // Arithmetic right shift of multiplier by 2 bits
            multiplier <= { {2{multiplier[15]}}, multiplier[15:2] };

            // Left shift multiplicand by 2 bits for next iteration
            multiplicand <= multiplicand << 2;

            ctr <= ctr + 1;
        end
        else begin
            // Multiplication complete
            rdy <= 1'b1;
            p <= product;
        end
    end
end

endmodule