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
    reg [1:0] prev_bit;  // For Booth recoding

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};  // Sign-extended multiplicand
            multiplier <= {{8{b[7]}}, b};    // Sign-extended multiplier
            p <= 16'b0;
            ctr <= 5'b0;
            rdy <= 1'b0;
            prev_bit <= 2'b0;
        end else begin
            if (ctr < 16) begin
                case (multiplier[1:0])
                    2'b00: ;  // No operation
                    2'b01: p <= p + multiplicand;  // Add multiplicand
                    2'b10: p <= p - multiplicand;  // Subtract multiplicand
                    2'b11: ;  // No operation (handled in next cycle)
                endcase

                // Booth recoding for next step
                prev_bit <= multiplier[1:0];
                multiplier <= {multiplier[15:2], 2'b0};  // Right shift by 2
                multiplicand <= multiplicand << 2;        // Left shift by 2 for next potential operation
                ctr <= ctr + 5'd2;                       // Increment by 2 (Radix-4)
            end else begin
                rdy <= 1'b1;  // Multiplication complete
            end
        end
    end

endmodule