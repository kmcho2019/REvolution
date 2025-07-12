module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;  // Sign-extended multiplicand
    reg [15:0] multiplier;    // Sign-extended multiplier + workspace
    reg [4:0] ctr;           // 5-bit counter (0-16)
    reg prev_lsb;            // Previous LSB for Booth encoding

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 5'b0;
            rdy <= 1'b0;
            prev_lsb <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 16) begin
                // Booth Radix-4 encoding (3 bits: multiplier[1:0] + prev_lsb)
                case ({multiplier[1:0], prev_lsb})
                    3'b000, 3'b111: ; // No operation
                    3'b001, 3'b010: p <= p + multiplicand;
                    3'b011: p <= p + (multiplicand << 1);
                    3'b100: p <= p - (multiplicand << 1);
                    3'b101, 3'b110: p <= p - multiplicand;
                endcase

                // Arithmetic right shift of product and multiplier
                {p, multiplier, prev_lsb} <= {p[15], p, multiplier[15:1]};
                
                ctr <= ctr + 1;
            end else begin
                // Multiplication complete
                rdy <= 1'b1;
            end
        end
    end

endmodule