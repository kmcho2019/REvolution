module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;  // 16-bit multiplicand with sign extension
    reg [7:0] multiplier;     // 8-bit multiplier
    reg [4:0] ctr;            // 5-bit counter (0-15)
    reg prev_bit;             // Previous bit for Booth encoding

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset
            multiplicand <= {{8{a[7]}}, a};  // Sign-extend to 16 bits
            multiplier <= b;
            p <= 16'b0;
            ctr <= 5'b0;
            prev_bit <= 1'b0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 16) begin
                // Booth Radix-4 encoding (examine 3 bits)
                case ({multiplier[1:0], prev_bit})
                    3'b000, 3'b111: ;  // +0: do nothing
                    3'b001, 3'b010: p <= p + multiplicand;  // +1
                    3'b011: p <= p + (multiplicand << 1);   // +2
                    3'b100: p <= p - (multiplicand << 1);   // -2
                    3'b101, 3'b110: p <= p - multiplicand;  // -1
                endcase

                // Update registers for next cycle
                multiplicand <= multiplicand << 1;  // Arithmetic left shift
                multiplier <= multiplier >> 1;      // Logical right shift
                prev_bit <= multiplier[0];
                ctr <= ctr + 1;
            end else begin
                // Multiplication complete
                rdy <= 1'b1;
            end
        end
    end

endmodule