module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;    // 16-bit sign-extended multiplicand
    reg [7:0] multiplier;       // 8-bit multiplier
    reg [4:0] ctr;             // 5-bit counter (0-15)
    reg prev_bit;              // Previous bit for Booth encoding

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize on reset
            multiplicand <= {{8{a[7]}}, a};  // Sign-extend to 16 bits
            multiplier <= b;
            p <= 16'b0;
            ctr <= 5'b0;
            prev_bit <= 1'b0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 16) begin
                // Booth encoding (Radix-4: examine 3 bits)
                case ({multiplier[1:0], prev_bit})
                    3'b000, 3'b111: ;  // +0: do nothing
                    3'b001, 3'b010: p <= p + multiplicand;       // +1×multiplicand
                    3'b011: p <= p + {multiplicand[14:0], 1'b0}; // +2×multiplicand
                    3'b100: p <= p - {multiplicand[14:0], 1'b0}; // -2×multiplicand
                    3'b101, 3'b110: p <= p - multiplicand;       // -1×multiplicand
                endcase

                // Arithmetic shift right multiplier by 2 (Radix-4)
                multiplier <= {multiplier[7], multiplier[7], multiplier[7:2]};
                prev_bit <= multiplier[1];

                // Shift left multiplicand by 2 for next partial product
                multiplicand <= {multiplicand[13:0], 2'b0};

                ctr <= ctr + 1;
            end else begin
                rdy <= 1'b1;  // Multiplication complete after 16 cycles
            end
        end
    end

endmodule