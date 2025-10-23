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
    reg [2:0] counter;  // 3-bit counter for 4 iterations (0-3)

    always @(posedge clk) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            counter <= 3'b0;
            rdy <= 1'b0;
        end else begin
            if (counter < 4) begin
                // Radix-4 Booth encoding (examine 3 bits)
                case (multiplier[2:0])
                    3'b000, 3'b111: p <= p;  // +0
                    3'b001, 3'b010: p <= p + multiplicand;  // +1
                    3'b011: p <= p + (multiplicand << 1);  // +2
                    3'b100: p <= p - (multiplicand << 1);  // -2
                    3'b101, 3'b110: p <= p - multiplicand;  // -1
                endcase

                // Update registers for next iteration
                multiplicand <= multiplicand << 2;
                multiplier <= multiplier >>> 2;  // Arithmetic right shift by 2
                counter <= counter + 1;
                rdy <= 1'b0;
            end else begin
                rdy <= 1'b1;  // Multiplication complete after 4 iterations
            end
        end
    end

endmodule