module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [7:0] multiplier;
    reg prev_lsb;
    reg [2:0] counter;  // Counts 0-3 (4 cycles for 8 bits)

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= b;
            prev_lsb <= 1'b0;
            p <= 16'b0;
            counter <= 3'b0;
            rdy <= 1'b0;
        end else begin
            if (counter < 4) begin
                // Booth encoding and operation
                case ({multiplier[1:0], prev_lsb})
                    3'b001, 3'b010: p <= p + multiplicand;
                    3'b011:         p <= p + (multiplicand << 1);
                    3'b100:         p <= p - (multiplicand << 1);
                    3'b101, 3'b110: p <= p - multiplicand;
                    default:        p <= p;  // 000,111: no operation
                endcase

                // Update registers for next cycle
                multiplicand <= multiplicand << 2;
                prev_lsb <= multiplier[1];
                multiplier <= multiplier >> 2;
                counter <= counter + 1;
                
                // Set ready when done
                rdy <= (counter == 3);
            end
        end
    end

endmodule