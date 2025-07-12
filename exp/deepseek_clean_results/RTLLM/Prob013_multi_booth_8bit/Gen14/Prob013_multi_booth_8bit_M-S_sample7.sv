module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // Extra bit for previous LSB
    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b, 1'b0};  // Initialize with b and prev_lsb=0
            p <= 16'b0;
            counter <= 0;
            rdy <= 0;
        end else begin
            if (counter < 4) begin
                // Booth Radix-4 operation
                case (multiplier[2:0])
                    3'b001, 3'b010: p <= p + multiplicand;
                    3'b011:        p <= p + (multiplicand << 1);
                    3'b100:        p <= p - (multiplicand << 1);
                    3'b101, 3'b110: p <= p - multiplicand;
                    default:       p <= p;  // 000, 111 - no operation
                endcase

                // Update registers for next cycle
                multiplicand <= multiplicand << 2;
                multiplier <= multiplier >> 2;
                counter <= counter + 1;
                rdy <= 0;
            end else begin
                rdy <= 1;  // Multiplication complete
            end
        end
    end

endmodule