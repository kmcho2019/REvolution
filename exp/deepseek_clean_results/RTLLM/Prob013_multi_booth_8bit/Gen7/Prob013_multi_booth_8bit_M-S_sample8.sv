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
    reg [1:0] counter;  // 2-bit counter for 4 iterations (0-3)
    reg prev_bit;

    always @(posedge clk) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            counter <= 2'b0;
            prev_bit <= 1'b0;
            rdy <= 1'b0;
        end else begin
            if (counter < 4) begin
                // Radix-4 Booth encoding (3 bits)
                case ({multiplier[1:0], prev_bit})
                    3'b000, 3'b111: p <= p;  // No operation
                    3'b001, 3'b010: p <= p + multiplicand;  // +1*M
                    3'b011:        p <= p + (multiplicand << 1);  // +2*M
                    3'b100:        p <= p - (multiplicand << 1);  // -2*M
                    3'b101, 3'b110: p <= p - multiplicand;  // -1*M
                endcase

                // Update for next iteration
                multiplicand <= multiplicand << 2;
                prev_bit <= multiplier[1];
                multiplier <= multiplier >>> 2;  // Arithmetic right shift
                counter <= counter + 1;
                rdy <= 1'b0;
            end else begin
                rdy <= 1'b1;  // Multiplication complete
            end
        end
    end

endmodule