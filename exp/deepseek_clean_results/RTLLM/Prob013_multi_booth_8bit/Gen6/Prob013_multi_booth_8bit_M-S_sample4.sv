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
    reg prev_lsb;

    always @(posedge clk) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            counter <= 3'b0;
            prev_lsb <= 1'b0;
            rdy <= 1'b0;
        end else begin
            if (counter < 4) begin
                // Booth encoding and operation
                case ({multiplier[1:0], prev_lsb})
                    3'b000, 3'b111: p <= p;
                    3'b001, 3'b010: p <= p + multiplicand;
                    3'b101, 3'b110: p <= p - multiplicand;
                    3'b011: p <= p + (multiplicand << 1);
                    3'b100: p <= p - (multiplicand << 1);
                endcase

                // Update registers for next iteration
                multiplicand <= multiplicand << 2;
                prev_lsb <= multiplier[0];
                multiplier <= multiplier >>> 2;  // Arithmetic right shift
                counter <= counter + 1;
                rdy <= 1'b0;
            end else begin
                rdy <= 1'b1;  // Multiplication complete
            end
        end
    end

endmodule