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
    reg [2:0] ctr;  // Only need 3 bits (0-4)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 3'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 4) begin
                // Booth Radix-4 encoding (look at 3 bits: multiplier[2:0])
                case (multiplier[2:0])
                    3'b000, 3'b111: p <= p;  // No operation
                    3'b001, 3'b010: p <= p + multiplicand;  // +A
                    3'b101, 3'b110: p <= p - multiplicand;  // -A
                    3'b011: p <= p + (multiplicand << 1);    // +2A
                    3'b100: p <= p - (multiplicand << 1);    // -2A
                endcase

                // Shift multiplicand left by 2 for next step
                multiplicand <= multiplicand << 2;
                // Shift multiplier right by 2 for next step
                multiplier <= multiplier >> 2;
                ctr <= ctr + 1;
            end else begin
                rdy <= 1'b1;  // Done after 4 cycles
            end
        end
    end

endmodule